# 99francs_platform
99francs Platform repository

В рамках выполнения домашнего задания полученного после лекции 
"Знакомство с Kubernetes",была проделана следующая работа:
 - Создан образ веб сервера на базе официального образа Nginx работающего из-под пользователя с UID 1001
 - Образ веб сервера размещён на Docker Hub
 - Были найдены причины падения приложения fronted, а именно: не хватало целого списка переменных, 
 которые были найдены в подсказках с нужными значениями. После добавления, контейнер перешёл в статус Running
