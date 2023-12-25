#!/bin/bash

# Поле 3x3
declare -a board
for i in {0..2}; do
    for j in {0..2}; do
        board[$((i * 3 + j))]=" "
    done
done

# Вывод поля
function display_board {
    echo "  1 2 3"
    echo " -------"
    for i in {0..2}; do
        echo "$((i + 1))|${board[$((i * 3))]} ${board[$((i * 3 + 1))]} ${board[$((i * 3 + 2))]}|"
    done
    echo " -------"
}

# Проверка выигрыша
function check_winner {
    local symbol=$1

    # Строки и столбцы
    for i in {0..2}; do
        if [ "${board[$((i * 3))]}" == "$symbol" ] && [ "${board[$((i * 3 + 1))]}" == "$symbol" ] && [ "${board[$((i * 3 + 2))]}" == "$symbol" ]; then
            return 0
        fi

        if [ "${board[$i]}" == "$symbol" ] && [ "${board[$((i + 3))]}" == "$symbol" ] && [ "${board[$((i + 6))]}" == "$symbol" ]; then
            return 0
        fi
    done

    # Диагонали
    if [ "${board[0]}" == "$symbol" ] && [ "${board[4]}" == "$symbol" ] && [ "${board[8]}" == "$symbol" ]; then
        return 0
    fi

    if [ "${board[2]}" == "$symbol" ] && [ "${board[4]}" == "$symbol" ] && [ "${board[6]}" == "$symbol" ]; then
        return 0
    fi

    return 1
}

# Начало игры
echo "Добро пожаловать в игру 'Крестики-нолики'!"
display_board

# Игра
while true; do
    # Ход компьютера (крестик)
    computer_move=$((RANDOM % 9))
    while [ "${board[$computer_move]}" != " " ]; do
        computer_move=$((RANDOM % 9))
    done

    board[$computer_move]="X"
    display_board

    # Проверяем выигрыш компьютера
    if check_winner "X"; then
        echo "Компьютер победил:("
        break
    fi

    # Ничья
    if [[ ! " ${board[@]} " =~ " " ]]; then
        echo "Ничья)."
        break
    fi

    # Ход игрока (нолик)
    read -p "Ваш ход. Введите номер ячейки (1-9): " player_move
    while [[ ! "$player_move" =~ ^[1-9]$ || "${board[$((player_move - 1))]}" != " " ]]; do
        read -p "Некорректный ввод. Введите номер ячейки (1-9): " player_move
    done

    board[$((player_move - 1))]="O"
    display_board

    # Проверка выигрыша игрока
    if check_winner "O"; then
        echo "Поздравляем! Вы победили!"
        break
    fi
done

