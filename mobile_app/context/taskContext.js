import React, { createContext, useState, useEffect } from "react";
import { db, auth } from '../config';
import { doc, getDoc, setDoc } from 'firebase/firestore';

export const TaskContext = createContext();

export const TaskProvider = ({ children }) => {
  const [tasks, setTasks] = useState([]);
  const [date, setDate] = useState(null);
  const [loading, setLoading] = useState(true); 
  const [mode, setMode] = useState('leisure');

  const getToday = () => new Date().toISOString().split('T')[0];

  // fetches tasks
  const fetchTasks = async (userID) => {
    try {
      const docRef = doc(db, "tasks", userID);
      const docSnap = await getDoc(docRef);

      if (docSnap.exists()) {
        const data = docSnap.data();
        setTasks(data.tasks || []);
        setDate(data.date || getToday());
        setMode(data.mode || 'leisure');
      } else {
        const newData = {
          tasks: [],
          date: getToday(),
          mode: 'leisure'
        };
        await setDoc(docRef, newData);
        setTasks([]);
        setDate(newData.date);
        setMode('leisure');
      }
    } catch (error) {
      console.log("Error fetching tasks:", error);
    } finally {
      setLoading(false);
    }
  };

  // saves tasks
  const saveTasksToFirebase = async (newTasks, newDate = null, newMode) => {
    try {
        const user = auth.currentUser;
        if (!user) return;

        const docRef = doc(db, "tasks", user.uid);

        const updateData = { tasks: newTasks };

        if (newDate) updateData.date = newDate;

        updateData.mode = newMode ?? mode;

        await setDoc(docRef, updateData, { merge: true });

        setTasks([...newTasks]);
        if (newDate) setDate(newDate);
        setMode(newMode ?? mode);

        console.log("Tasks saved!");
    } catch (error) {
        console.log("Error saving tasks:", error);
    }
    };

  // listens for login state
  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((user) => {
      if (user) fetchTasks(user.uid);
      else {
        setTasks([]);
        setDate(null);
        setMode('leisure');
        setLoading(false);
      }
    });

    return () => unsubscribe();
  }, []);

  return (
    <TaskContext.Provider value={{ tasks, setTasks, date, setDate, saveTasksToFirebase, loading, mode, setMode }}>
      {children}
    </TaskContext.Provider>
  );
};
