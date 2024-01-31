# constype



# PLAN:

* print out any text serialized from file as set of chars
* overlay it on terminal
* overlay it via serialization (save to file)


# challenges

- изменение размеров окна терминала должно приводить к заполнению по ширине с сохранением логической позиции курсора 
- возможно потребуется отображение лигатур 
- однозначно потребуется нормализация лигатур (enter -> \n )
- 
- 


со стороны пользователя пока что будет интерфейс примерно на такое поведение (ActorContract)

readSymbolWithPrinting()
backspace()
enter()
gracefulShutdown()


со стороны текста контракт следующий (TextContract)

coordOfPrevChar()
coordOfNextChar()
rewriteLine()

со стороны терминала контракт такой (диктуется библиотекой, тут будет минимальная обертка) (TtyContract)

up(n)
down(n)
left(n)
right(n)
currentPosition()
goto(x , y)
readSymbolWithPrinting()
readSymbolWithNoPrinting()


