    import React, {useState, useEffect} from 'react';
    import {Text, View, StyleSheet, Dimensions, SafeAreaView, TouchableOpacity, Button} from 'react-native';

    const windowWidth = Dimensions.get('window').width
    const windowHeight = Dimensions.get('window').height

    const Tasks =({title, time, completed, completeTask, completeAll, mode})=>{

        return(
                <View style={[styles.taskContainer, {
                    backgroundColor: (completed === 0 || completed ===2 )&& !completeAll?
                     "#ffffffff": completed ===1||completed===-1 && mode==="sequential"?"#cde0f28d":"#c8c9caff"
                    }]}>
                    <View style={styles.textContainer}>
                        <Text style={[styles.text,{color: (completed === 0 || completed ===2 )&& !completeAll? "#000000ff" :"#445769ff" }]} numberOfLines={2}>
                            {title}
                        </Text>
                        <Text style={[styles.text,{color: (completed === 0 || completed ===2 )&& !completeAll? "#000000ff" :"#445769ff" }]}>
                            {time}
                        </Text>
                    </View>        
                    <TouchableOpacity onPress={()=>completeTask()} disabled={completeAll||completed===-1}>
                        <View style={[styles.checkbox, completed === 1 && styles.checkboxChecked || completed===-1 && mode==="sequential"&& styles.checkboxChecked ]}>
                            {completed === 1 && <Text style={styles.checkmark}>✓</Text>}
                            {(completed === -1 && mode==="sequential") && <Text style={styles.checkmark}>✓</Text>}
                        </View>
                    </TouchableOpacity>
                </View>
                
        )

    }

    const styles = StyleSheet.create({
        taskContainer:{
            backgroundColor: "#ecf2f8ff",
            width: windowWidth * 0.9,
            height: windowHeight * 0.10,
            flexDirection: 'row',
            justifyContent: 'space-between',
            alignItems: 'center',
            paddingLeft: 40,
            paddingRight:30,
            borderRadius: 10,
            marginTop: 5,
            marginBottom: 5,
            shadowColor: '#000',
            shadowOffset: { width: 0, height: 2 },
            shadowOpacity: 0.1,
            shadowRadius: 4,
            elevation: 3
        },

        textContainer:{
            flexShrink: 1, //wraps text
            flexGrow: 1,
            maxWidth: '60%'
        },
        buttonContainer:{
            backgroundColor: 'rgba(233, 247, 255, 1)',
            width: '20%',
            height: '30%',
            alignItems: 'center',
            justifyContent: 'center',
            borderRadius: 10
        },
        
        text: {
            fontSize: 18
        },

        checkbox: {
            width: 24,
            height: 24,
            borderWidth: 2,
            borderColor: "#333",
            borderRadius: 4,
            marginRight: 12,
            alignItems: "center",
            justifyContent: "center",
        },

        checkboxChecked: {
            backgroundColor: "#85d388ff",
        },

        checkmark: {
            color: "white",
            fontWeight: "bold",
        }
    })

    export default Tasks
