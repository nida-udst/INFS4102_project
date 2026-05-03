import React, { useState, useContext, useCallback } from 'react';
import { useFocusEffect } from '@react-navigation/native';
import { SafeAreaView, Dimensions, ScrollView, StyleSheet, Text, View, TouchableOpacity, Alert } from 'react-native';

import TasksEdit from '../components/tasksEdit';
import { TaskContext } from '../context/taskContext';

const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

const Edit = () => {
  const { tasks, setTasks, saveTasksToFirebase } = useContext(TaskContext);
  const [newTasks, setNewTasks] = useState([...tasks]);

  // Update newTasks every time screen is focused
  useFocusEffect(
    useCallback(() => {
      setNewTasks([...tasks]);
    }, [tasks])
  );

  // Add a new empty task
  const addTask = () => {
    setNewTasks(prev => [
      ...prev,
      { title: "", time: "", completed: 2 }
    ]);
    
  };

  // Sort tasks by time
  const sortTasks = (tasksArray) => {
    return [...tasksArray].sort((a, b) => {
      const [h1, m1] = a.time.split(":").map(Number);
      const [h2, m2] = b.time.split(":").map(Number);
      return h1 * 60 + m1 - (h2 * 60 + m2);
    });
  };

  // Update tasks and save to Firebase
  const updateTasks = async () => {

    // Validation: check for empty title or invalid time
    for (let i = 0; i < newTasks.length; i++) {
      const task = newTasks[i];
      if (!task.title.trim()) {
        Alert.alert("Invalid Task", `Task #${i + 1} is missing a title.`);
        return;
      }
      if (!/^\d{1,2}:\d{2}$/.test(task.time)) {
        Alert.alert("Invalid Task", `Task #${i + 1} has an invalid time. Use HH:MM format.`);
        return;
      }
      const [h, m] = task.time.split(':').map(Number);
      if (h > 23 || m > 59) {
        Alert.alert("Invalid Task", `Task #${i + 1} has an invalid hour or minute.`);
        return;
      }
    }

    const sortedTasks = sortTasks(newTasks);  // sort before saving
    setTasks(sortedTasks);                     // update global state
    await saveTasksToFirebase(sortedTasks);    // save sorted tasks

    // Proper alert
    Alert.alert(
      "Tasks Successfully Updated",
      "If you have completed today's routine, your new tasks will be available the next day.",
      [{ text: "Great!" }]
    );
  };

  const handleDeleteTask = (idx) => {
  setNewTasks(prev => prev.filter((_, i) => i !== idx));
  setTimeout(() => {
    Alert.alert(
      "Task Deleted!",
      "A task has been deleted,\n press save to confirm your changes."
    );
  }, 50);
};




  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.tasksContainer}>
        <ScrollView>
          {newTasks.map((task, i) => (
            <TasksEdit
              key={i}
              idx={i}
              title={task.title}
              time={task.time}
              completed={task.completed}
              onChange={(updatedTask) => {
                setNewTasks(prev => {
                  const arr = [...prev];
                  arr[i] = updatedTask;
                  return arr;
                });
              }}
              deleteTask={() => handleDeleteTask(i)}
            />
          ))}
        </ScrollView>
      </View>

      <View style={styles.lastRow}>
        <TouchableOpacity style={styles.bttnContainer} onPress={addTask}>
          <Text style={styles.text}>Add Task</Text>
        </TouchableOpacity>

        <TouchableOpacity style={[styles.bttnContainer, {backgroundColor: "#7ac299ff"}]} onPress={updateTasks}>
          <Text style={styles.text}>Save</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#252b3fff',
  },

  lastRow: {
    justifyContent: 'space-evenly',
    alignItems: 'center',
    height: '10%',
    flexDirection: 'row',
    margin:10
  },

  tasksContainer: {
    backgroundColor: '#ffffff11',
    justifyContent: 'center',
    alignItems: 'center',
    height: '73%',
    
  },



    bttnContainer:{
        backgroundColor: '#acb1c5ff',
        borderRadius: 15,
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 5 },
        shadowOpacity: 0.3,
        shadowRadius: 6,
        elevation: 8,
        width: '35%',
        height: '80%',
        justifyContent: 'center',
        alignItems: 'center',
        borderWidth: 2.5,
        borderColor: "white"
    },

  text: {
    fontSize: 18,
  },
});

export default Edit;
