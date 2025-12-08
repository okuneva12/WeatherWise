#!/bin/bash

# Скрипт для коммита изменений и создания тега lr6 через Git Bash

echo "=== WeatherWise - Коммит и создание тега lr6 ==="
echo ""

# Переход в директорию проекта
cd "$(dirname "$0")" || exit

# Проверка, что мы в git репозитории
if [ ! -d .git ]; then
    echo "ОШИБКА: Не найден git репозиторий!"
    echo "Инициализируйте репозиторий: git init"
    exit 1
fi

echo "✓ Git репозиторий найден"
echo ""

# Проверка статуса
echo "Текущий статус Git:"
git status --short
echo ""

# Подтверждение
read -p "Продолжить коммит и создание тега? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Отменено пользователем."
    exit 1
fi

# Добавление всех изменений
echo ""
echo "Добавление всех файлов..."
git add .

# Проверка, есть ли что коммитить
if git diff --staged --quiet; then
    echo "Нет изменений для коммита."
    read -p "Создать тег lr6 для текущего коммита? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # Проверка, существует ли тег
        if git rev-parse "lr6" >/dev/null 2>&1; then
            echo ""
            read -p "Тег lr6 уже существует. Удалить и пересоздать? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]
            then
                git tag -d lr6
                git push origin :refs/tags/lr6 2>/dev/null || true
            else
                echo "Отменено."
                exit 1
            fi
        fi
        
        git tag -a lr6 -m "Лабораторная работа 6: Работа с данными (БД и HTTP API)"
        echo "✓ Тег lr6 создан"
        echo ""
        read -p "Отправить тег на GitHub? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            git push origin lr6
            echo "✓ Тег lr6 отправлен на GitHub"
        fi
    fi
    exit 0
fi

# Создание коммита
echo ""
echo "Создание коммита..."
COMMIT_MESSAGE="ЛР6: Работа с данными (БД и HTTP API)

- Реализовано локальное хранение через SharedPreferences
- Интегрирован OpenWeatherMap API
- Данные отображаются в интерфейсе
- Реализована архитектура по Flutter guidelines:
  * Repository слой
  * Service слой (WeatherService, StorageService)
  * ViewModel слой
  * Dependency Injection через GetIt
- Улучшена обработка ошибок
- Исправлены все предупреждения линтера"

git commit -m "$COMMIT_MESSAGE"

if [ $? -ne 0 ]; then
    echo "ОШИБКА: Не удалось создать коммит"
    exit 1
fi

echo "✓ Коммит создан"
echo ""

# Проверка наличия remote
REMOTE_EXISTS=$(git remote | grep -c "^origin$" || echo "0")
if [ "$REMOTE_EXISTS" -eq 0 ]; then
    echo "⚠️  Remote 'origin' не найден"
    read -p "Введите URL репозитория GitHub (или нажмите Enter для пропуска): " REPO_URL
    if [ -n "$REPO_URL" ]; then
        git remote add origin "$REPO_URL"
        echo "✓ Remote 'origin' добавлен"
    else
        echo "Пропущено добавление remote"
    fi
fi

# Отправка на GitHub
if git remote | grep -q "^origin$"; then
    read -p "Отправить изменения на GitHub? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo ""
        echo "Отправка коммитов..."
        CURRENT_BRANCH=$(git branch --show-current)
        git push origin "$CURRENT_BRANCH"
        
        if [ $? -ne 0 ]; then
            echo "⚠️  Не удалось отправить изменения. Возможно, нужно настроить upstream:"
            echo "   git push -u origin $CURRENT_BRANCH"
        else
            echo "✓ Изменения отправлены на GitHub"
        fi
    fi
fi

# Создание тега
echo ""
if git rev-parse "lr6" >/dev/null 2>&1; then
    echo "⚠️  Тег lr6 уже существует"
    read -p "Удалить и пересоздать тег lr6? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        git tag -d lr6
        git push origin :refs/tags/lr6 2>/dev/null || true
    else
        echo "Тег не изменен"
        exit 0
    fi
fi

echo "Создание тега lr6..."
git tag -a lr6 -m "Лабораторная работа 6: Работа с данными (БД и HTTP API)

Реализовано:
- Локальное хранение через SharedPreferences
- Интеграция с OpenWeatherMap API
- Отображение данных в интерфейсе
- Архитектура по Flutter guidelines"

echo "✓ Тег lr6 создан"
echo ""

# Отправка тега
if git remote | grep -q "^origin$"; then
    read -p "Отправить тег lr6 на GitHub? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        git push origin lr6
        if [ $? -eq 0 ]; then
            echo "✓ Тег lr6 отправлен на GitHub"
        else
            echo "⚠️  Не удалось отправить тег"
        fi
    fi
fi

echo ""
echo "=== Готово ==="
echo ""
echo "Коммит: $(git log -1 --oneline)"
echo "Тег lr6: $(git describe --tags lr6 2>/dev/null || echo 'не отправлен')"
echo ""

