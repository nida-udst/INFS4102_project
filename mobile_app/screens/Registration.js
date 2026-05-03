import { StyleSheet,Dimensions, Text, View,SafeAreaView, TextInput, TouchableOpacity, Alert } from 'react-native'
import React,{useState} from 'react'
import {auth,db} from '../config'
import { createUserWithEmailAndPassword, signInWithEmailAndPassword } from "firebase/auth";

const {width,height} = Dimensions.get('window')
const myFontSize = (width+height)*0.02
const Registration = ({navigation}) => {
    const [email,setEmail] = useState();
    const [password,setPassword] = useState();

    //state of user, whether they are signed in or not
    const [signedIn, setSignedIn] = useState(false);

    //register user, creating a new email and password authentication
    const handleRegister = () => {
       createUserWithEmailAndPassword(auth, email, password)
        //successful --> registered
        .then(() => 
        Alert.alert(
              "Account Successfully Created!",
              "Login and start creating your routine."
            )
        )
        //unsuccessful --> error
        .catch((error) => console.log(error))
        }
    

    //handles user log ins
    const handleLogin = () => {
        signInWithEmailAndPassword(auth, email, password)
        //successful --> Logged in
        .then(() => {
        console.log('Logged in')
        //redirects to the main screens
        navigation.replace('MainTabs');
        })
        //unsuccessful --> error message
        .catch((error) => {console.log(error.message);
        setSignedIn(false)})
        }
  return (
    <SafeAreaView style={styles.container}>
        <Text style={styles.title}>DailyFlow</Text>
        <Text style={{fontWeight: 'bold', fontSize: 25, color: '#ffd700'}}>Welcome!</Text>
        {/**
         * Email input, stores user input into 'email'
         */}
      <TextInput placeholder='Email' 
      style={styles.txtIn} 
      onChangeText={(txt)=>setEmail(txt)}/>

      {/**
         * Password input, stores user input into 'password', hides input with secureTextEntry
         */}
      <TextInput placeholder='Password' secureTextEntry={true}
      style={styles.txtIn} 
      onChangeText={(txt)=>setPassword(txt)}/>

        {/** Triggers handleLogin */}
     <View style={styles.bttnContainer}>
        <TouchableOpacity style={styles.touch}
        onPress={handleLogin}>
            <Text style={styles.txt}>Login</Text>
        </TouchableOpacity>

        {/** Triggers handleRegister */}
        <TouchableOpacity style={styles.touch}
        onPress={handleRegister}>
            <Text style={styles.txt}>Register</Text>
        </TouchableOpacity>
    </View>
    </SafeAreaView>
  )
}

export default Registration

const styles = StyleSheet.create({
    title:{
        fontSize: myFontSize*1.5,
        fontWeight: 'bold',
        paddingBottom: height*0.08,
        color:'#ffffffff'},
    container:{
        flex:1,
        justifyContent:'center',
        alignItems:'center',
        backgroundColor:'#4b527a'
    },
    txtIn:{
        backgroundColor:'snow',
        padding:myFontSize*0.5,
        width:width*0.85,
        marginTop:height*0.02,
        borderRadius:10
    },
    touch:{
        width:width/4,
        backgroundColor:'#252b3fff',
        marginTop:height*0.02,
        padding:myFontSize*0.5,
        borderRadius:10,
        margin: 10
    },
   txt: {
        alignSelf: 'center',
        color: "#ffffffff"
        
   },
   bttnContainer:{
    flexDirection: 'row'
   }
})