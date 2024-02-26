return {
	__closed = false,
	Close = function(self)
		self.__closed = true
	end,

	Start = function(self, signalStream, childController)
		local controller = childController(self)
		controller:Load()

		while not self.__closed do
			local atomicSignal = signalStream()
			local action = controller:HandleSignal(atomicSignal)
			action(controller, atomicSignal)
		end

		controller:Close()
	end,
}
