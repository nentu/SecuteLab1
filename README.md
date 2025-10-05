# Проект безопасного веб-API

## Обзор

В этом проекте реализован безопасный веб-API с использованием Python и Flask framework с аутентификацией JWT и комплексными мерами безопасности. API обеспечивает аутентификацию пользователей и защиту конечных точек данных, а также включает в себя множество рекомендаций по обеспечению безопасности.

## Краткое описание реализации задачи

### 1. Стек использованный для реазизации проекта 
- **Стек технологий**: Python с платформой Flask
- **Управление пакетами**: pip с requirements.txt
- **Управление версиями**: Репозиторий Git инициализирован и подключен к удаленному
- **База данных**: SQLite для упрощения работы с SQLAlchemy ORM

### 2. Разработка функционального API
Реализованы три конечные точки API:
1. **POST /auth/login** - Конечная точка аутентификации пользователя
2. **GET /api/data** - Защищенная конечная точка данных (требуется аутентификация)
3. **GET /api/users** - Дополнительная защищенная конечная точка для составления списка пользователей

### 3. Реализация безопасности
- **Защита от внедрения SQL**: Используется ORM SQLAlchemy с параметризованными запросами
- **Защита XSS**: Реализовано экранирование выходных данных с помощью функции escape() Flask
- **Безопасность аутентификации**:
  - Токены JWT с истекшим сроком действия для аутентификации
  - Хэширование паролей с использованием алгоритма bcrypt
  - Промежуточное программное обеспечение для проверки JWT на защищенных конечных точках

### 4. Конвейер CI/CD со сканированием безопасности
- Сконфигурирован рабочий процесс GitHub Actions (.github/workflows/ci.yml)
- Реализован SAST (Статическое тестирование безопасности приложений) с использованием Bandit
- Реализован SCA (Анализ состава программного обеспечения) с использованием Safety
- Автоматическое сканирование безопасности при каждом push-запросе

### 5. Тестирование и документация
- Создан комплексный тестовый скрипт (test_jwt.sh) для тестирования API
- Проверена функциональность аутентификации с помощью curl и Postman
- Сгенерированы и просмотрены отчеты о проверке безопасности

## Структура проекта

```
secure-api/
├── app.py # Основное приложение Flask
├── config.py # Параметры конфигурации
├── requirements.txt # Зависимости Python
├── test_jwt.sh # Скрипт на Bash для тестирования API
├── .github/
│ └── workflows/
│    └── ci.yml # Действия на GitHub для настройки CI/CD
└── README.md # Этот файл
```

## Описание ключевых файлов

### app.py
Основное приложение Flask, содержащее:
- Определение пользовательской модели с хэшированием паролей
- Конфигурация JWT и промежуточное программное обеспечение
- Реализация конечных точек API:
  - POST /auth/login - Аутентификация пользователя
  - GET /api/data - защищенной конечной точки данных
  - GET /api/users - защищенной конечной точки списка пользователей
- Инициализация базы данных

### config.py
Параметры конфигурации приложения, включая:
- Секретные ключи для Flask и JWT
- URI подключения к базе данных
- Конфигурации, зависящие от среды

### requirements.txt
Список всех зависимостей Python:
- Веб-фреймворк Flask
- Flask-SQLAlchemy для ORM базы данных
- Flask-JWT-Extended для аутентификации JWT
- Bcrypt для хэширования паролей

### test_jwt.sh
Скрипт Bash для комплексного тестирования API:
- Проверяет функциональность входа в систему
- Проверяет генерацию токенов JWT
- Проверяет доступ к защищенным конечным точкам
- Проверяет меры безопасности (недействительные токены, отсутствие аутентификации)
- Предоставляет выходные данные с цветовой кодировкой для упрощения проверки

### .github/workflows/ci.yml
Конфигурация действий GitHub для конвейера CI/CD:
- Автоматическое сканирование безопасности по push- и pull-запросам
- Бандитское сканирование SAST на наличие кода на Python
- Проверка SCA безопасности на наличие уязвимостей в зависимостях
- Генерация артефактов для отчетов о безопасности

## Настройка и установка

1. Клонируем репозиторий:
```bash
git clone https://github.com/nentu/SecuteLab1
cd secure-api
```

2. Создайте и активируйте виртуальную среду:
```bash
python -m venv
source venv/bin/activate # В Windows: venv\Scripts\activate
```

3. Установите зависимости:
```bash
pip install -r requirements.txt
```

4. Запустите приложение:
```bash
python app.py
```

## Проверка безопастности

После запуска SAST утилиты bandit была найдена одна ошибка. Я пускал flask приложение в debug режиме.

![alt text](imgs/image.png)

Исправили в коде эту строку и CI/CD пайплайн был пройден!

![alt text](imgs/image2.png)

В артифактах pipelin'а можно найти логи проверок.

### Bandit
![alt text](imgs/image3.png)

### Safety

![alt text](imgs/image4.png)

## Тестирование

### Ручное тестирование с помощью curl
```bash
# Получение токена JWT
curl -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"admin"}' http://localhost:5000/auth/login

# Доступ к защищенной конечной точке (заменить <токен> на фактический JWT)
curl -H "Authorization: Bearer <token>" http://localhost:5000/api/data
```

**Результаты**

```bash
curl -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"admin"}' http://localhost:5000/auth/login
# {"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc1OTY1MzY4MiwianRpIjoiNmY0ODAwNGItMzg4Ni00YmE4LTk3MTAtZDlhNTRiOGQwY2U0IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IjEiLCJuYmYiOjE3NTk2NTM2ODIsImNzcmYiOiIyOWNhNjE4Ny0wY2I0LTQ3NzgtYWRhOC05ZmRkODE0ODcwMzUiLCJleHAiOjE3NTk2NTcyODJ9.YQJvCm9RxPuRAXL_IgKzvDrBdXdqFIc7Zi12oJjxpro"}
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTc1OTY1MzY4MiwianRpIjoiNmY0ODAwNGItMzg4Ni00YmE4LTk3MTAtZDlhNTRiOGQwY2U0IiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IjEiLCJuYmYiOjE3NTk2NTM2ODIsImNzcmYiOiIyOWNhNjE4Ny0wY2I0LTQ3NzgtYWRhOC05ZmRkODE0ODcwMzUiLCJleHAiOjE3NTk2NTcyODJ9.YQJvCm9RxPuRAXL_IgKzvDrBdXdqFIc7Zi12oJjxpro" http://localhost:5000/api/data
# {"data":["Secret1","Secret2"]}
```

### Автоматическое тестирование
Запустите сценарий комплексного тестирования:
```bash
chmod +x test_jwt.sh
./test_jwt.sh
```

**Результаты**:

![alt text](imgs/image5.png)

Этот проект демонстрирует безопасную реализацию API с комплексными мерами безопасности, автоматизированным тестированием и интеграцией CI/CD для постоянного мониторинга безопасности.
