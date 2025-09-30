# Используем базовый JDK образ
FROM eclipse-temurin:17-jdk-jammy

# Рабочая директория в контейнере
WORKDIR /app

# Копируем готовый jar в контейнер
COPY target/app.jar /app/app.jar

# Указываем команду для запуска приложения
ENTRYPOINT ["java", "-jar", "app.jar"]

# Открываем порт 8080
EXPOSE 8080
