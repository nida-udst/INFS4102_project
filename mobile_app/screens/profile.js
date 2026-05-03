import React, { useContext } from 'react';
import { SafeAreaView, Dimensions, StyleSheet, Text, View, TouchableOpacity, Alert } from 'react-native';
import { getAuth, signOut } from 'firebase/auth';
import { TaskContext } from '../context/taskContext';

const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

const Profile = ({ navigation }) => {
  const { mode, setMode, saveTasksToFirebase, tasks, setTasks } = useContext(TaskContext);

  const handleLogout = async () => {
    const auth = getAuth();
    try {
      await signOut(auth);
      navigation.replace('Registration');
    } catch (error) {
      console.log('Error logging out:', error);
    }
  };

  const toggleMode = () => {
    // Check if all tasks are completed in current mode
    const allCompletedCurrentMode = tasks.length > 0 && tasks.every(
      t => (mode === 'leisure' && t.completed === 1 || t.completed === 2) || (mode === 'sequential' && t.completed === -1 || t.completed === 2)
    );

    if (allCompletedCurrentMode) {
      Alert.alert(
        "Cannot Switch Mode",
        "All tasks are already completed in the current mode. You cannot switch."
      );
      return;
    }

    // Confirm reset for switching
    Alert.alert(
      "Switch Mode",
      "Switching mode will reset all tasks. Continue?",
      [
        {
          text: "Cancel",
          style: "cancel"
        },
        {
          text: "Yes",
          onPress: () => {
            const newMode = mode === 'leisure' ? 'sequential' : 'leisure';
            const resetTasks = tasks.map(t => ({ ...t, completed: 0 }));

            setTasks(resetTasks);
            setMode(newMode);
            saveTasksToFirebase(resetTasks, null, newMode);

            console.log("Mode switched to:", newMode);
          }
        }
      ]
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>

        {/* User Info */}
        <View style={styles.card}>
          <Text style={styles.cardLabel}>Logged in as</Text>
          <Text style={styles.cardValue}>{getAuth().currentUser?.email || 'N/A'}</Text>
        </View>

        {/* Mode Switch */}
        <TouchableOpacity style={styles.modeButton} onPress={toggleMode}>
          <Text style={styles.modeButtonText}>
            Switch to {mode === 'leisure' ? 'Sequential' : 'Leisure'}
          </Text>
        </TouchableOpacity>

        {/* Logout Button */}
        <TouchableOpacity style={styles.button} onPress={handleLogout}>
          <Text style={styles.buttonText}>Logout</Text>
        </TouchableOpacity>

      </View>
    </SafeAreaView>
  );
};

export default Profile;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#252b3fff',
    alignItems: 'center',
    width: windowWidth,
    height: windowHeight,
  },

  content: {
    width: '100%',
    padding: 20,
    alignItems: 'center',
  },

  card: {
    backgroundColor: '#4b527a',
    width: '90%',
    padding: 20,
    borderRadius: 12,
    marginBottom: 30,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },

  cardLabel: {
    fontSize: 14,
    color: '#ffd700',
    marginBottom: 8,
    textTransform: 'uppercase',
    fontWeight: '600',
  },

  cardValue: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#fff',
  },

  modeButton: {
    backgroundColor: '#5a7ad0',
    paddingVertical: 14,
    paddingHorizontal: 40,
    borderRadius: 12,
    marginBottom: 25,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },

  modeButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },

  button: {
    backgroundColor: '#a15959',
    paddingVertical: 14,
    paddingHorizontal: 40,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },

  buttonText: {
    color: '#fff',
    fontWeight: 'bold',
    fontSize: 16,
  },
});
