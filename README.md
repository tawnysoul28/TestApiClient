# TestApiClient

Суть задания
Написать приложение, которое будет взаимодействовать с каким-либо
интернет-сервисом (на выбор) через предоставляемое API. Пример:
YouTube-клиент, GitHub-клиент, WordPress-клиент и так далее. Главные
требования к сервису:

— взаимодействие через HTTP(s) API,
использование специализированных SDK не допускается;
— cервис должен уметь предоставлять список объектов, поиск
по объектам и детальную информацию об объекте. Например,
в случае с YouTube это будет список видео, поиск видео по
названию и информация о видео с возможностью просмотра.

На первой странице приложения, после авторизации (если необходимо),
пользователь должен видеть строку поиска и пустую таблицу.
После ввода поискового запроса и нажатия кнопки Search
отображается индикатор загрузки. Таблица при этом остаётся
доступной для пользователя, он может производить любые операции
с находящимися в ней данными (если это, например, не первый поиск,
и какие-то данные там уже есть). После получения данных от сервера
таблица заполняется в формате, указанном на рисунке. При нажатии
на ячейку пользователь попадает на страницу с подробным описанием
элемента, где, например, в случае с видео, видна информация
о продолжительности, авторе, тегах и пр. При нажатии на миниатюру
приложение переходит на экран проигрывания видео.

Дополнительные задания для уровня Developer
(достаточно выполнить любые два либо последний):
— Реализовать Lazy Loading для миниатюр на первом экране;
— реализовать функции Pull To Refresh и Load More
(можно воспользоваться сторонним компонентом c http://
cocoacontrols.com);
— добавить на экран информации о видео все миниатюры, которые
возвращаются с сервера (можно разместить их на UIScrollView
между самим видео и его описанием);
— добавить возможность чтения комментариев и комментирования
элемента. Секция комментариев должна быть расположена
под секцией Description, весь экран должен прокручиваться.
