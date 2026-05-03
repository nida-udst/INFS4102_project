import React from 'react';
import { Text, View, StyleSheet, Dimensions, SafeAreaView, TouchableOpacity, TextInput } from 'react-native';

const windowWidth = Dimensions.get('window').width;
const windowHeight = Dimensions.get('window').height;

const TasksEdit = ({ time, title, completed, onChange, deleteTask, idx }) => {


  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.taskContainer}>
        <View style={styles.textContainer}>
          {/* Display index */}
          <Text style={styles.indexText}>{idx + 1}</Text>

          <TextInput
            style={styles.text}
            value={title}
            placeholder='Title'
            onChangeText={(text) => onChange({ title: text, time, completed })}
          />

          <TextInput
            style={styles.text}
            value={time}
            placeholder='HH:MM'
            keyboardType='numeric'
            maxLength={5}
            onChangeText={(text) => onChange({ title, time: text, completed})}
          />
        </View>
      </View>

      <View style={styles.deleteContainer}>
        <TouchableOpacity onPress={() => deleteTask()}>
          <Text>❌</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    width: windowWidth,
    paddingLeft: 50,
    paddingRight: 30,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center'
  },
  taskContainer: {
    backgroundColor: "#e8eaf7ff",
    width: windowWidth * 0.8,
    height: windowHeight * 0.13,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingLeft: 20,
    paddingRight: 30,
    borderRadius: 10,
    marginTop: 5,
    marginBottom: 5,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
    borderWidth: 2,
    borderColor: '#9da6c7ff',
  },
  textContainer: {
    flexShrink: 1,
    flexGrow: 1,
    maxWidth: '60%'
  },
  text: {
    fontSize: 18,
    paddingTop: 0,
    paddingBottom: 0,
    marginBottom: 5,
    width: 200,
    borderWidth: 1,
    borderColor: "#46688aff"
  },
  deleteContainer: {
    width: '9%',
    justifyContent: 'center',
    alignItems: 'center',
    margin: 10
  },
  indexText: {
  fontSize: 18,
  fontWeight: 'bold',
  marginRight: 10,
  color: '#333',
  paddingBottom: 10
}

});

export default TasksEdit;
