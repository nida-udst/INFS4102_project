import React, { createContext, useState, useEffect } from "react";

import {db, auth} from '../config';
import { collection, getDoc, onSnapshot, doc, setDoc, updateDoc } from 'firebase/firestore';

export const ProgressContext = createContext();

export const ProgressProvider = ({ children }) => {
    const [progress, setProgress] = useState([])
    
    // fetchTasks now accepts userID and does not assume auth.currentUser exists
    const fetchProgress = async (userID) => {
        try {
            if (!userID) return;
            const docRef = doc(db, "progress", userID);
            const docSnap = await getDoc(docRef);

            if (docSnap.exists()) {
                setProgress(docSnap.data() || []);
            } else {
                const data = {
                    streak:0,
                    max: 0,
                    missed: [],
                    start_date: (new Date()).toISOString().split('T')[0]
                }
                await setDoc(docRef, data);
                setProgress(data)
            }
        } catch (error) {
            console.log("Error fetching progress:", error);
        }
    }

    const saveProgressToFirebase = async (newProgress) => {
        try {
            const user = auth.currentUser;
            if (!user) return;
            const userID = user.uid;
            const docRef = doc(db, "progress", userID);
            const docSnap = await getDoc(docRef);

            if (docSnap.exists()) {
                await updateDoc(docRef, newProgress);
            } else {
                const data = {
                    streak: 0,
                    max: 0,
                    missed: [],
                    start_date: (new Date()).toISOString().split('T')[0]
                };
                await setDoc(docRef, data);
            }
            setProgress(newProgress);
            console.log("Progress saved to Firebase!");
            return true
        } catch (e) {
            console.error("Error saving progress:", e);
        }

    };

    useEffect(() => {
        const unsubscribe = auth.onAuthStateChanged((user) => {
            if (user) {
                fetchProgress(user.uid);   
            } else {
                setProgress([]);           
            }
        });

        return () => unsubscribe();
    }, []);

    return (
        <ProgressContext.Provider value={{ progress, setProgress, saveProgressToFirebase}}>
            {children}
        </ProgressContext.Provider>
    );
};
