import { getFirestore } from 'firebase/firestore'
import { getAuth } from 'firebase/auth'

// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyBD9-vG-apkDHP0A3HFcgzbbWp6YBUG2CY",
  authDomain: "dailyflow-b29d5.firebaseapp.com",
  projectId: "dailyflow-b29d5",
  storageBucket: "dailyflow-b29d5.firebasestorage.app",
  messagingSenderId: "956311232464",
  appId: "1:956311232464:web:b0485e06ad2e37975b23d5"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

export const db = getFirestore(app)
export const auth = getAuth(app)