return {
	__closed = false,
	Close = function(self)
		self.__closed = true
	end,

	Start = function(self, signalStream, childController)
		local sig = childController(self)
		sig:Load()

		while not self.__closed do
			local atomicSignal = signalStream()
			local action = sig:HandleSignal(atomicSignal)
			action(atomicSignal)
		end

		sig:Close()
	end,
}
