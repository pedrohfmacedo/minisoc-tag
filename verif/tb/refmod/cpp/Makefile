# unix/linux
# main:
# 	g++ -Wall -std=c++0x -lcryptopp -o prog main.cpp 
# 	./prog

CRYPTOPP_PREFIX ?= $(HOME)/cryptopp_local

# main:
#     g++ -Wall -std=c++11 -o prog main.cpp -lcryptopp
#     ./prog

main:
	g++ -Wall -std=c++0x -I$(CRYPTOPP_PREFIX)/include -L$(CRYPTOPP_PREFIX)/lib -o prog main.cpp -lcryptopp
	./prog
clean:
	rm -rf prog
