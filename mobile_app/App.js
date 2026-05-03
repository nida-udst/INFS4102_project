import React, { useState, useEffect, createContext } from 'react';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaView, Dimensions, ScrollView, StyleSheet, Text, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';


import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createDrawerNavigator, DrawerContentScrollView, DrawerItem } from '@react-navigation/drawer';

//screens imports
import Home from './screens/home';
import Edit from './screens/edit';
import Progress from './screens/progress';
import Profile from './screens/profile';
import Registration from './screens/Registration';
import { TaskProvider } from './context/taskContext';
import { ProgressProvider } from './context/progressContext';

//firebase imports
import { db, auth } from './config';
import { collection, getDoc, onSnapshot, doc } from 'firebase/firestore';


//navigator
const Tab = createBottomTabNavigator()
const Stack = createNativeStackNavigator()
const Drawer = createDrawerNavigator();

const windowWidth = Dimensions.get('window').width
const windowHeight = Dimensions.get('window').height

export default function App() {

  function MainTabs({ navigation }) {
    return (
      <Tab.Navigator
        screenOptions={({ route }) => ({
          headerRight: () => (
            <Ionicons name="menu" size={30} style={{ color: 'white', paddingRight: 15 }} onPress={() => navigation.openDrawer()} />
          ),
          headerStyle: {
            backgroundColor: '#5d648eff',
            height: 100,
            shadowColor: '#000',
            shadowOffset: { width: 0, height: 2 },
            shadowOpacity: 0.3,
            shadowRadius: 3,
            elevation: 5,
          },
          headerTitleStyle: {
            fontWeight: 'bold',
            fontSize: 22,
            color: '#ffffffff',
          },
          tabBarShowLabel: true,
          tabBarStyle: {
            backgroundColor: '#5d648eff',
            paddingBottom: 10,
            borderTopLeftRadius: 20,
            borderTopRightRadius: 20,
            shadowColor: '#000',
            shadowOffset: { width: 0, height: -3 },
            shadowOpacity: 0.3,
            shadowRadius: 5,
            elevation: 10,
          },
          tabBarActiveTintColor: '#ffd700',
          tabBarInactiveTintColor: '#fff',
          tabBarLabelStyle: {
            fontSize: 12,
            fontWeight: 'bold',
          },
          tabBarIcon: ({ focused, color, size }) => {
            let iconName;
            if (route.name === 'Home') iconName = focused ? 'home' : 'home-outline';
            else if (route.name === 'Edit') iconName = focused ? 'create' : 'create-outline';
            else if (route.name === 'Progress') iconName = focused ? 'stats-chart' : 'stats-chart-outline';
            else if (route.name === 'Profile') iconName = focused ? 'person' : 'person-outline';

            return <Ionicons name={iconName} size={size} color={color} />;
          },
        })}
      >
        <Tab.Screen name='Home' component={Home} />
        <Tab.Screen name='Edit' component={Edit} />
        <Tab.Screen name='Progress' component={Progress} />
        <Tab.Screen name='Profile' component={Profile} />
      </Tab.Navigator>
    )
  }


  function DrawerLayout() { 
    function CustomDrawerContent(props) { 
      const { navigation } = props; 
      return (
      <DrawerContentScrollView {...props}> 
        <DrawerItem label="Home" onPress={() => navigation.navigate('MainTabs', { screen: 'Home' })} labelStyle={{ fontWeight: 'bold' }} /> 
        <DrawerItem label="Edit" onPress={() => navigation.navigate('MainTabs', { screen: 'Edit' })} labelStyle={{ fontWeight: 'bold' }} /> 
        <DrawerItem label="Progress" onPress={() => navigation.navigate('MainTabs', { screen: 'Progress' })} labelStyle={{ fontWeight: 'bold' }} /> 
        <DrawerItem label="Profile" onPress={() => navigation.navigate('MainTabs', { screen: 'Profile' })} labelStyle={{ fontWeight: 'bold' }} /> 
      </DrawerContentScrollView>); 
      } 
    return (
      <Drawer.Navigator 
        drawerContent={(props) => <CustomDrawerContent {...props} />} 
        screenOptions={{ 
          drawerPosition:'right',
          headerShown: false, 
          drawerActiveTintColor: '#ffd700', 
          drawerInactiveTintColor: '#333', 
          drawerStyle: { backgroundColor: '#fff', width: 250, }}}>
        <Drawer.Screen name="MainTabs" component={MainTabs} options={{ drawerLabel: 'Home' }} />
      </Drawer.Navigator>); }

  return (
    <ProgressProvider>
      <TaskProvider>
        <NavigationContainer>
          <Stack.Navigator>
            <Stack.Screen name='Registration'
              component={Registration}
              options={{
                tabBarStyle: { display: 'none' },
                headerShown: false,
              }} />
            <Stack.Screen name="MainTabs" component={DrawerLayout} options={{ headerShown: false }} />
          </Stack.Navigator>
        </NavigationContainer>
      </TaskProvider>
    </ProgressProvider>
  );
}

const styles = StyleSheet.create({

});