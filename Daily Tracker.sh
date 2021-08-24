# Author            : Piotr Gorkowski ( s184515@student.pg.edu.pl )
# Created On        : 19.05.2021
# Last Modified By  : Piotr Gorkowski ( s184515@student.pg.edu.pl )
# Last Modified On  : 19.05.2021
# Version           : 1.0
#
#Description        : Daily Tracker to track your everyday activities
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)

#!/bin/bash
DATE="$(date +%d%m%y)"
DATAFILENAME="data.json"
EVERYDAYFILENAME="$DATE.json"


clear
if [[ ! -f "$EVERYDAYFILENAME" ]]; then
    jq -Rn > $EVERYDAYFILENAME
fi

if [[ ! -f "$DATAFILENAME" ]]; then
    jq -Rn > $DATAFILENAME
fi

version () {
    echo "Version 1.0"
    echo "Author Piotr Gorkowski ( s184515@student.pg.edu.pl )"
    exit 0
}

help () {
    echo "To start with the Daily Tracker set up your preferences!"
    exit 0
}

while getopts hvf:q GOPT; do
    case $GOPT in
    h) help;;
    v) version;;
    *) echo "Unknown Option!"
        exit 0;;
    esac
done

#Ustawiam codzienne nawyki jezeli nawyki nie sa zapisane badz chca byc zmienione
#czyszcze liste nawykow oraz czy zostaly wykonane
setHabit() { 
    printf "\n" 
    bool=0
    contents="$(jq '.habit = {}' $DATAFILENAME)" && \
    echo "${contents}" > $DATAFILENAME
    contents="$(jq '.day.isHabitDone = {}' $EVERYDAYFILENAME)" && \
    echo "${contents}" > $EVERYDAYFILENAME
    habitIterator=1
    while [[ $bool -eq 0 ]]
    do
        echo "Set your habit: "
        read habit
        contents="$(jq '.habit."'"$habitIterator"'" = "'"$habit"'"' $DATAFILENAME)" && \
        echo "${contents}" > $DATAFILENAME
        habitIterator=$[$habitIterator+1]
        echo "Press y to stop or any key to set more habits!"
        read ans
        if [[ $ans == "y" ]]
        then
            bool=1
        fi
        clear
    done
    contents="$(jq '.habit.quantity = "'"$habitIterator"'"' $DATAFILENAME)" && \
    echo "${contents}" > $DATAFILENAME
}

#Dodaje rzeczy do zrobienia danego dnia mozna wracac i dodawac kolejne rzeczy
setToDo() {
    printf "\n"
    bool=0
    todoIterator=$(jq -r '.day.toDoCounter' $EVERYDAYFILENAME)
    if [[ $todoIterator = "null" ]]; then
        todoIterator=1
    fi
    while [[ $bool -eq 0 ]]
    do
        echo "Set your todo: "
        read habit
        contents="$(jq '.day.todoList."'"$todoIterator"'" = "'"$habit"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        todoIterator=$[$todoIterator+1]
        echo "Press y to stop or any key to set more habits!"
        read ans
        if [[ $ans == "y" ]]
        then
            bool=1
        fi
        clear
    done
    contents="$(jq '.day.toDoCounter = "'"$todoIterator"'"' $EVERYDAYFILENAME)" && \
    echo "${contents}" > $EVERYDAYFILENAME
}

#Wprowadzane dane zapisuja sie w pliku json i beda wykorzystane do wygenerowania zapotrzebowania kalorycznego
setAboutMe() {
    printf "\n"
    choice=0
    sex=0
    weight="null"
    height="null"
    age="null"
    destination="null"
    weeks="null"
    echo "Put data about you:"
    for (( i=1; i<=6; i++ ))
    do
        case "$i" in
            "1")
                while [[ $sex != "male" ]] && [[ $sex != "female" ]]
                do
                    clear
                    echo "Enter your sex [male or female]: "
                    read sex
                done
                contents="$(jq '.aboutMe.sex = "'"$sex"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
                clear
            ;;
            "2")
                while [[ ! $weight =~ ^[0-9]+$ ]]
                do
                    clear
                    echo "Enter your weight [kilograms]: "
                    read weight
                done
                contents="$(jq '.aboutMe.weight = "'"$weight"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
                clear
            ;;
            "3")
                while [[ ! $height =~ ^[0-9]+$ ]]
                do
                    clear
                    echo "Enter your height [centimeters]: "
                    read height
                done
                contents="$(jq '.aboutMe.height = "'"$height"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
                clear
            ;;
            "4")
                while [[ ! $age =~ ^[0-9]+$ ]]
                do
                    clear
                    echo "Enter your age: "
                    read age
                done
                contents="$(jq '.aboutMe.age = "'"$age"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
                clear
            ;;
            "5")
                while [[ ! $destination =~ ^[0-9]+$ ]]
                do
                    clear
                    echo "What is your destinated weight [kilograms]: "
                    read destination
                done
                contents="$(jq '.aboutMe.destination = "'"$destination"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
                clear
            ;;
            "6")
                while [[ ! $weeks =~ ^[0-9]+$ ]]
                do
                    clear
                    echo "How many weeks would you like to change your weight: "
                    read weeks
                done
                contents="$(jq '.aboutMe.time = "'"$weeks"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
                clear
            ;;
        esac
    done
    while [[ ! $choice -gt 0 ]] || [[ $choice -gt 5 ]]
    do
        clear
        echo "Determine your activity factor: "
        echo "1. Sedentary (little or no exercise)"
        echo "2. Lightly active (light exercise/sports 1-3 days/week)"
        echo "3. Moderately active (moderate exercise/sports 3-5 days/week):" 
        echo "4. Very active (hard exercise/sports 6-7 days a week)"
        echo "5. If you are extra active (very hard exercise/sports & a physical job)"
        read choice
        case "$choice" in
            "1")
                contents="$(jq '.aboutMe.activityFactor = "1.2"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
            ;;
            "2")
                contents="$(jq '.aboutMe.activityFactor = "1.375"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
            ;;
            "3")
                contents="$(jq '.aboutMe.activityFactor = "1.55"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
            ;;
            "4")
                contents="$(jq '.aboutMe.activityFactor = "1.725"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
            ;;
            "5")
                contents="$(jq '.aboutMe.activityFactor = "1.9"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
            ;;
        esac
    done
    clear
    checkDiet
}

#Na podstawie wczesniej wyliczonych danych generowane jest zapotrzebowanie kaloryczne
checkDiet() {
    printf "\n"
    sex=$(jq -r '.aboutMe.sex' $DATAFILENAME)
    weight=$(jq -r '.aboutMe.weight' $DATAFILENAME)
    height=$(jq -r '.aboutMe.height' $DATAFILENAME)
    age=$(jq -r '.aboutMe.age' $DATAFILENAME)
    desiredWeight=$(jq -r '.aboutMe.destination' $DATAFILENAME)
    activityFactor=$(jq -r '.aboutMe.activityFactor' $DATAFILENAME)
    weeks=$(jq -r '.aboutMe.time' $DATAFILENAME)
    case "$sex" in
        "male")
        BMR='python3 -c "print(round((10*"'"$weight"'"+6.25*"'"$height"'"-5*"'"$age"'"+5)*"'"$activityFactor"'"))"'
        ;;
        "female")
        BMR='python3 -c "print(round((10*"'"$weight"'"+6.25*"'"$height"'"-5*"'"$age"'"-161)*"'"$activityFactor"'"))"'
        ;;
    esac

    neutralCalories=$(eval "$BMR")
    contents="$(jq '.aboutMe.neutralCalories = "'"$neutralCalories"'"' $DATAFILENAME)" && \
    echo "${contents}" > $DATAFILENAME
    if [[ $weight > $desiredWeight ]]
    then
        temp=$[$weight-$desiredWeight]
        newCal='python3 -c "print("'"$temp"'"/"'"$weeks"'")"'
        yParameter=$(eval "$newCal")
        temp2='python3 -c "print(round("'"$yParameter"'"*1000))"'
        diet=$(eval "$temp2")
        arg=$[$neutralCalories-$diet]
        generateDiet "$arg"
    fi
    if [[ $weight < $desiredWeight ]]
    then
        temp=$[$desiredWeight-$weight]
        newCal='python3 -c "print("'"$temp"'"/"'"$weeks"'")"'
        yParameter=$(eval "$newCal")
        temp2='python3 -c "print(round("'"$yParameter"'"*1000))"'
        diet=$(eval "$temp2")
        arg=$[$diet+$neutralCalories]
        generateDiet "$arg"
    fi
    if [[ $weight == $desiredWeight ]]
    then
        generateDiet "$neutralCalories"
    fi 
}

#Na podstawie wczesniej wyliczonych danych uzupelniane sa wszystkie dane w pliku json
generateDiet() {
    for (( i=1; i<=4; i++ ))
    do
        case "$i" in
            "1")
                contents="$(jq '.diet.calories = "'"$1"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
            ;;
            "2")
                temp1='python3 -c "print(round(("'"$1"'"*0.2)/4))"'
                proteins1=$(eval "$temp1")
                temp2='python3 -c "print(round("'"$1"'"*0.12/4))"'
                proteins2=$(eval "$temp2")
                arg="$proteins2 - $proteins1"
                contents="$(jq '.diet.proteins = "'"$arg"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
            ;;
            "3")
                temp1='python3 -c "print(round("'"$1"'"*0.3/9))"'
                fats1=$(eval "$temp1")
                temp2='python3 -c "print(round("'"$1"'"*0.25/9))"'
                fats2=$(eval "$temp2")
                arg="$fats2 - $fats1"
                contents="$(jq '.diet.fats = "'"$arg"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
            ;;
            "4")
                temp1='python3 -c "print(round("'"$1"'"*0.70/4))"'
                carbohydrates1=$(eval "$temp1")
                temp2='python3 -c "print(round("'"$1"'"*0.45/4))"'
                carbohydrates2=$(eval "$temp2")
                arg="$carbohydrates2 - $carbohydrates1"
                contents="$(jq '.diet.carbohydrates= "'"$arg"'"' $DATAFILENAME)" && \
                echo "${contents}" > $DATAFILENAME
            ;;
        esac
    done
}

#jezeli istnieje todo jest wyswietlane
printToDo() {
    data=$(jq -r '.day.toDoCounter' $EVERYDAYFILENAME)
    printf "\n"
    if [[ $data = "null" ]]; then
        echo "You have nothing to do today!"
    else
        echo "Here are your things to do today!"
        jq -r '.day.todoList[]' $EVERYDAYFILENAME
    fi
    printf "\n"
}

#jezeli istnieja nawyki sa wyswietlane
checkHabit() {
    iterator=$(jq -r '.habit.quantity' $DATAFILENAME)
    printf "\n"
    if [[ $iterator = "null" ]]; then
        echo "You should fill your habit list!"
    else
        for (( i=1; i<=$iterator-1; i++ ))
        do
            arg=$(jq -r '.habit."'"$i"'"' $DATAFILENAME)
            echo "Did you do: $arg today? Write a comment about this activity!"
            read ans
            contents="$(jq '.day.isHabitDone."'"$i"'" = "'"$ans"'"' $EVERYDAYFILENAME)" && \
            echo "${contents}" > $EVERYDAYFILENAME
            clear
        done
    fi

}

#pokazywana jest calosc dnia na podstawie danych wprowadzonych przez uzytkownika
printMyDay()
{
    echo "Here is your day!"
    printf "\n"

    iterator=$(jq -r '.habit.quantity' $DATAFILENAME)
    printf "\n"
    if [[ $iterator = "null" ]]; then
        echo "You have no habits to display!"
    else
        echo "Habits: "
        printf "\n"
        for (( i=1; i<=$iterator-1; i++ ))
        do
            arg=$(jq -r '.habit."'"$i"'"' $DATAFILENAME)
            ans=$(jq -r '.day.isHabitDone."'"$i"'"' $EVERYDAYFILENAME)
            if [[ $ans = "null" ]]; then
                echo "$arg"
            else
                echo "$arg - $ans"
            fi
        done
    fi
    printf "\n"

    printToDo

    printf "\n"
    
    mealIterator=$(jq -r '.day.meals' $EVERYDAYFILENAME)
    if [[ $mealIterator = "null" ]]; then
        echo "There are no meals to display!"
        printf "\n"
    else
        echo "Your meals: "
        printf "\n"
        for (( i=1; i<=$mealIterator-1; i++ ))
        do
            arg=$(jq -r '.day.menu."'"$i"'".name' $EVERYDAYFILENAME)
            echo "Name: $arg"

            arg=$(jq -r '.day.menu."'"$i"'".calories' $EVERYDAYFILENAME)
            echo "Calories: $arg"

            arg=$(jq -r '.day.menu."'"$i"'".fats' $EVERYDAYFILENAME)
            echo "Fats: $arg"

            arg=$(jq -r '.day.menu."'"$i"'".carbohydrates' $EVERYDAYFILENAME)
            echo "Carbohydrates: $arg"

            arg=$(jq -r '.day.menu."'"$i"'".proteins' $EVERYDAYFILENAME)
            echo "Proteins: $arg"

            printf "\n"
        done
            
        printf "\n"

        cal1=$(jq -r '.day.eaten.calories' $EVERYDAYFILENAME)
        cal2=$(jq -r '.diet.calories' $DATAFILENAME)
        fat1=$(jq -r '.day.eaten.fats' $EVERYDAYFILENAME)
        fat2=$(jq -r '.diet.fats' $DATAFILENAME)
        prot1=$(jq -r '.day.eaten.proteins' $EVERYDAYFILENAME)
        prot2=$(jq -r '.diet.proteins' $DATAFILENAME)
        carbs1=$(jq -r '.day.eaten.carbohydrates' $EVERYDAYFILENAME) 
        carbs2=$(jq -r '.diet.carbohydrates' $DATAFILENAME) 
        
        echo "Your caloric demands: "
        echo "$cal1 / $cal2 calories [kcal]"
        echo "$fat1 / $fat2 fats [g]"
        echo "$prot1 / $prot2 proteins [g]"
        echo "$carbs1 / $carbs2 carbohydrates [g]"
        printf "\n"
    fi
}

#dodawanie posilku
addMeal() {
    printf "\n"
    bool=0
    iterator=$(jq -r '.day.meals' $EVERYDAYFILENAME)
    if [[ $iterator = "null" ]]; then
        iterator=1
    fi
    while [[ $bool -eq 0 ]]
    do
        cal=$(jq -r '.day.eaten.calories' $EVERYDAYFILENAME)
        prot=$(jq -r '.day.eaten.proteins' $EVERYDAYFILENAME)
        carbs=$(jq -r '.day.eaten.carbohydrates' $EVERYDAYFILENAME)
        fat=$(jq -r '.day.eaten.fats' $EVERYDAYFILENAME)

        echo "Add your meal: "
        read meal
        contents="$(jq '.day.menu."'"$iterator"'".name = "'"$meal"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        printf "\n"

        calories="null"
        while [[ ! $calories =~ ^[0-9]+$ ]]
        do
            clear
            echo "Calories: "
            read calories
        done
        contents="$(jq '.day.menu."'"$iterator"'".calories = "'"$calories"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        tempCal=$[$cal+$calories]
        contents="$(jq '.day.eaten.calories = "'"$tempCal"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        printf "\n"

        fats="null"
        while [[ ! $fats =~ ^[0-9]+$ ]]
        do
            clear
            echo "Fats: "
            read fats
        done
        contents="$(jq '.day.menu."'"$iterator"'".fats = "'"$fats"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        tempFat=$[$fat+$fats]
        contents="$(jq '.day.eaten.fats = "'"$tempFat"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        printf "\n"

        carbohydrates="null"
        while [[ ! $carbohydrates =~ ^[0-9]+$ ]]
        do
            clear
            echo "Carbohydrates: "
            read carbohydrates
        done
        contents="$(jq '.day.menu."'"$iterator"'".carbohydrates = "'"$carbohydrates"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        tempCarbohydrates=$[$carbs+$carbohydrates]
        contents="$(jq '.day.eaten.carbohydrates = "'"$tempCarbohydrates"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        printf "\n"

        proteins="null"
        while [[ ! $proteins =~ ^[0-9]+$ ]]
        do
            clear
            echo "Proteins: "
            read proteins
        done
        contents="$(jq '.day.menu."'"$iterator"'".proteins = "'"$proteins"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        tempProteins=$[$prot+$proteins]
        contents="$(jq '.day.eaten.proteins = "'"$tempProteins"'"' $EVERYDAYFILENAME)" && \
        echo "${contents}" > $EVERYDAYFILENAME
        printf "\n"

        habitIterator=$[$habitIterator+1]

        iterator=$[$iterator+1]

        echo "Press y to stop or any key to add more meals!"
        read ans
        if [[ $ans == "y" ]]
        then
            bool=1
        fi
        clear
    done
    contents="$(jq '.day.meals= "'"$iterator"'"' $EVERYDAYFILENAME)" && \
    echo "${contents}" > $EVERYDAYFILENAME
}

#Funkcja sprawdzajaca czy uzytkownik uzupelnil dane i zostala wygenerowana dieta
checkIfDietIsSet() {
    calo=$(jq -r '.diet.calories' $DATAFILENAME)
    printf "\n"
    if [[ $calo = "null" ]]; then
        echo "You should set your diet before adding meals!"
    else
        addMeal
    fi
}

#Cale menu
option=0
while [[ $option -ne 7 ]]
do
    echo "Daily Tracker"
    echo "1. Habit Tracker"
    echo "2. Fit Tracker"
    echo "3. To-do List"
    echo "4. Preferences"
    echo "5. My Day"
    echo "6. Save your Day"
    echo "7. Quit Application"

    echo -n "Choose an option:"
    read option

    case "$option" in

        "1")
            clear
            checkHabit
            ;;

        "2")
            clear
            checkIfDietIsSet
            ;;

        "3")
            clear
            printToDo
            ;;

        "4")
            clear
            echo "What would you like to set?"
            echo "1. Set Habit"
            echo "2. Set To Do List"
            echo "3. Set Your Diet"
            read opt
            if [[ $opt -eq 1 ]] 
            then
                setHabit
            fi
            if [[ $opt -eq 2 ]] 
            then
                setToDo
            fi
            if [[ $opt -eq 3 ]] 
            then
                setAboutMe
            fi
            ;;

        "5")
            clear
            printMyDay
            ;;  
       
        "6")
            printMyDay > $DATE.txt
            clear
            echo "Saved!"
            ;;  

        "7")
            printMyDay > $DATE.txt
            echo "Thanks for using!"
            ;;  

        *)
            clear
            echo "Incorrect value!"
            ;;
    esac
done

