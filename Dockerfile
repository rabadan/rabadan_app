# Используйте официальный образ Ruby в качестве базового образа
FROM ruby:3.2.2

# Установка зависимостей системы
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Создание рабочей директории в контейнере и установка зависимостей Ruby
WORKDIR /rabadan_app
COPY Gemfile /rabadan_app/Gemfile
COPY Gemfile.lock /rabadan_app/Gemfile.lock
RUN bundle install

# Копирование файлов приложения в контейнер
COPY . /rabadan_app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Запуск приложения при старте контейнера
CMD ["rails", "server", "-b", "0.0.0.0"]