# constype

# plan


-- PLAN:
--
-- print out any text serialized from file as set of chars
-- overlay it on terminal
-- overlay it via serialization (save to file)
--


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


