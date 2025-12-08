#!/bin/bash

# Скрипт для запуска Flutter приложения через Git Bash

echo "=== WeatherWise - Запуск приложения ==="
echo ""

# Проверка наличия Flutter
if ! command -v flutter &> /dev/null
then
    echo "ОШИБКА: Flutter не найден в PATH"
    echo "Добавьте Flutter в переменную PATH или запустите:"
    echo "export PATH=\$PATH:/c/Users/Виктория/flutter/bin"
    exit 1
fi

echo "✓ Flutter найден"
echo ""

# Переход в директорию проекта (если скрипт запущен не из неё)
cd "$(dirname "$0")" || exit

echo "Текущая директория: $(pwd)"
echo ""

# Очистка предыдущих сборок (опционально)
read -p "Выполнить 'flutter clean'? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Очистка проекта..."
    flutter clean
    echo ""
fi

# Получение зависимостей
echo "Получение зависимостей..."
flutter pub get
echo ""

# Проверка доступных устройств
echo "Доступные устройства:"
flutter devices
echo ""

# Выбор действия
echo "Выберите действие:"
echo "1) Запустить на подключенном устройстве/эмуляторе"
echo "2) Запустить в режиме отладки (debug)"
echo "3) Запустить в режиме релиза (release)"
echo "4) Собрать APK (debug)"
echo "5) Собрать APK (release)"
read -p "Введите номер (1-5): " choice

case $choice in
    1)
        echo "Запуск приложения..."
        flutter run
        ;;
    2)
        echo "Запуск в режиме отладки..."
        flutter run --debug
        ;;
    3)
        echo "Запуск в режиме релиза..."
        flutter run --release
        ;;
    4)
        echo "Сборка APK (debug)..."
        flutter build apk --debug
        echo ""
        echo "✓ APK собран: build/app/outputs/flutter-apk/app-debug.apk"
        ;;
    5)
        echo "Сборка APK (release)..."
        flutter build apk --release
        echo ""
        echo "✓ APK собран: build/app/outputs/flutter-apk/app-release.apk"
        ;;
    *)
        echo "Неверный выбор. Запуск по умолчанию..."
        flutter run
        ;;
esac

echo ""
echo "=== Готово ==="


