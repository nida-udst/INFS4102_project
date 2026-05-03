import React, { useState, useEffect, useContext } from 'react';
import { SafeAreaView, Dimensions, ScrollView, StyleSheet, Text, View, Alert } from 'react-native';
import Tasks from '../components/tasks';
import { TaskContext } from '../context/taskContext';
import { ProgressContext } from '../context/progressContext';

const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

const Home = () => {
  const { tasks, setTasks, date, setDate, saveTasksToFirebase, loading, mode  } = useContext(TaskContext);
  const { progress, saveProgressToFirebase } = useContext(ProgressContext);
  const [completeAll, setCompleteAll] = useState(false);

  useEffect(() => {
    if (!loading && tasks !== null && date !== null) {
      initializeTasks();
    }
  }, [loading, date]);

  const getTodayDate = () => new Date().toISOString().split('T')[0];
  const getYesterdayDate = () => {
    const today = new Date();
    today.setDate(today.getDate() - 1);
    return today.toISOString().split('T')[0];
  };

  const completeTask = async (idx) => {
    // Guard: ensure task exists
    if (!tasks || !tasks[idx]) return;

    // If sequential mode, validate once before toggling
    if (mode === 'sequential' && idx > 0 && Number(tasks[idx - 1].completed) !== -1 && Number(tasks[idx - 1].completed) !== 2) {
      Alert.alert("Sequential Mode", "Please complete the previous task first.", [{ text: 'OK', onPress: () => {} }]);
      return;
    }

    const prevAllCompleted = tasks.length > 0 && tasks.every(task => Number(task.completed) === 1);

    // Toggle only the targeted task
    const updatedTasks = tasks.map((t, i) => i === idx ? { ...t, completed: mode==="sequential"?-1:t.completed === 1 ? 0 : 1 } : t);

    setTasks(updatedTasks);
    await saveTasksToFirebase(updatedTasks);

    const nowAllCompleted = updatedTasks.length > 0 && updatedTasks.every(task => Number(task.completed) === 1) || (mode==="sequential" && updatedTasks.every(task => Number(task.completed) === -1)) ;
    if (nowAllCompleted && !prevAllCompleted) await continueStreak();
  };

  const continueStreak = async () => {
    const newProgress = {
      ...progress,
      streak: progress.streak + 1,
      max: progress.streak + 1 > progress.max ? progress.streak + 1 : progress.max,
      start_date: progress.start_date === null ? getTodayDate() : progress.start_date,
      missed: tasks.filter(t => t.completed === 0)
    };
    await saveProgressToFirebase(newProgress);
    setCompleteAll(true);
    Alert.alert(
      "Keep Going! 🔥",
      `Your streak is now ${newProgress.streak} day${newProgress.streak !== 1 ? 's' : ''}!`,
      [{ text: "Great!" }]
    );
  };

  const endStreak = async () => {
    const missedTasks = tasks.filter(t => Number(t.completed) === 0);
    const newProgress = { ...progress, streak: 0, missed: missedTasks, start_date: null };
    await saveProgressToFirebase(newProgress);
    Alert.alert(
      "Streak Ended",
      `${progress.streak >= progress.max ? "🎉 You've reached your highest streak! Aim even higher next time! 💪" : "Don't lose your spirit! Keep Going!"}`,
      [{ text: "OK" }]
    );
  };

  const initializeTasks = async () => {
    const todayDate = getTodayDate();
    const yesterdayDate = getYesterdayDate();

    if (!date || tasks.length === 0) {
      setCompleteAll(false);
      return;
    }

    if (date === todayDate) {
      if (
        (tasks.every(task => task.completed === 1 || task.completed === 2) ||
        (mode==="sequential" && tasks.every(task => task.completed === -1 || task.completed === 2))) &&
         !tasks.every(task => task.completed === 2)) {

          setCompleteAll(true);
        Alert.alert("All Done! 🎉", "You have completed your tasks for today!", [{ text: "Great!" }]);

      } else setCompleteAll(false);
    } else {
      if (date !== yesterdayDate || (!tasks.every(task => task.completed === 1 || task.completed === 2) || (mode==="sequential" && !tasks.every(task => task.completed === -1 || task.completed === 2))) || tasks.every(task => task.completed === 2)) {
        await endStreak();
      }
      const resetTasks = tasks.map(t => ({ ...t, completed: 0 }));
      setTasks(resetTasks);
      setCompleteAll(false);
      await saveTasksToFirebase(resetTasks, todayDate);
      setDate(todayDate);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Header Card */}
      <View style={styles.headerCard}>
        <Text style={styles.headerText}>Today: {date}</Text>
        <Text style={styles.headerSubText}>
          Streak: {progress.streak} day{progress.streak>1?'s':''}{completeAll ? '🔥' : ''}
        </Text>
      </View>

      {/* Task List */}
      <ScrollView contentContainerStyle={styles.tasksContainer}>
        {tasks.length > 0 ? tasks.map((task, i) => (
          <Tasks
            key={i}
            title={task.title}
            time={task.time}
            completed={task.completed}
            completeTask={() => completeTask(i)}
            completeAll={completeAll}
            mode={mode}
          />
        )) : (
          <View style={styles.noTasks}>
            <Text style={styles.noTasksText}>No Tasks Available</Text>
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#252b3fff',
  },
  headerCard: {
    margin: 20,
    padding: 20,
    backgroundColor: '#4b527a',
    borderRadius: 15,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.3,
    shadowRadius: 6,
    elevation: 8,
  },
  headerText: {
    fontSize: 22,
    fontWeight: 'bold',
    color: '#fff',
  },
  headerSubText: {
    fontSize: 16,
    marginTop: 5,
    color: '#ffd700',
  },
  tasksContainer: {
    paddingHorizontal: 20,
    paddingBottom: 110,
  },
  noTasks: {
    marginTop: 50,
    alignItems: 'center',
  },
  noTasksText: {
    fontSize: 18,
    color: '#fff',
  },
});

export default Home;
