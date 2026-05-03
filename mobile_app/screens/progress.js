import React, { useContext } from 'react';
import { SafeAreaView, Dimensions, ScrollView, StyleSheet, Text, View } from 'react-native';
import { ProgressContext } from '../context/progressContext';

const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

const Progress = () => {
  const { progress } = useContext(ProgressContext);

  const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    const date = new Date(dateString + 'T00:00:00');
    return date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.content}>

        {/* Start Date */}
        <View style={styles.card}>
          <Text style={styles.cardLabel}>Current Streak Started</Text>
          <Text style={styles.cardValue}>{formatDate(progress.start_date)}</Text>
        </View>

        {/* Streak & Max Streak Row */}
        <View style={styles.row}>
          <View style={[styles.card, styles.rowCard]}>
            <Text style={styles.cardLabel}>Current{"\n"}Streak</Text>
            <Text style={styles.cardValue}>{progress.streak || 0} 🔥</Text>
            <Text style={styles.cardSubtext}>day{progress.streak>progress.max?'s':''}</Text>
          </View>

          <View style={[styles.card, styles.rowCard]}>
            <Text style={styles.cardLabel}>Max{"\n"}Streak</Text>
            <Text style={styles.cardValue}>{progress.max || 0} ⭐</Text>
            <Text style={styles.cardSubtext}>days</Text>
          </View>
        </View>

        {/* Missed Tasks */}
        <View style={[styles.card, styles.missedCard]}>
          <Text style={[styles.cardLabel, {color: '#000000'}]}>Previously Missed Tasks</Text>
          {progress.missed && progress.missed.length > 0 ? (
            <ScrollView style={styles.missedList}>
              {progress.missed.map((task, i) => (
                <View key={i} style={styles.missedItem}>
                  <Text style={styles.missedTitle}>{task.title}</Text>
                  <Text style={styles.missedTime}>{task.time}</Text>
                </View>
              ))}
            </ScrollView>
          ) : (
            <Text style={styles.noMissedText}>No missed tasks! 🎉</Text>
          )}
        </View>

      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#252b3fff',
  },

  content: {
    padding: 20,
    paddingBottom: 80,
  },

  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },

  rowCard: {
    width: '48%', // two cards side by side
  },

  card: {
    backgroundColor: '#4b527a',
    borderRadius: 12,
    padding: 20,
    marginVertical: 12,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },

  missedCard: {
    backgroundColor: '#f5e6e6ff',
    minHeight: 150,
  },

  cardLabel: {
    fontSize: 14,
    color: '#ffd700',
    marginBottom: 8,
    textTransform: 'uppercase',
    fontWeight: '600',
  },

  cardValue: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#ffffffff',
  },

  cardSubtext: {
    fontSize: 15,
    color: '#ffd700',
    marginTop: 4,
  },

  missedList: {
    width: '100%',
    maxHeight: 300,
  },

  missedItem: {
    backgroundColor: '#fff',
    padding: 12,
    marginVertical: 8,
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: '#d9534f',
  },

  missedTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
  },

  missedTime: {
    fontSize: 12,
    color: '#999',
    marginTop: 4,
  },

  noMissedText: {
    fontSize: 16,
    color: '#27ae60',
    fontWeight: '600',
    marginTop: 20,
  },
});

export default Progress;
