##
## BENOIT PROJECT, 2020
## GTA
## File description:
## Makefile
##

#=========	COMPILER OPTIONS	=========
CXX			=	g++

CPPFLAGS	=	-W -Wall -Wpedantic -Wextra -Wshadow -Wstrict-overflow=5 -Wmissing-declarations -Wundef		\
				-Wstack-protector -Wno-unused-parameter -Wunreachable-code -march=native -pipe -std=c++17	\
				-Woverloaded-virtual  -Wdisabled-optimization -Winline -Wredundant-decls -Wsign-conversion 	\
				-I $(INCLUDE) -lpthread																		\

#=========	BINARIES NAMES	=========
BIN			=	GTA_Cheat

#=========	FILES NAMES	=========
INCLUDE 	= 	include/									\

SOURCE		=	cheat_code_finder.cpp						\



SRC_MAIN	=	$(addprefix source/,$(SOURCE))				\
				source/main.cpp								\

SRC_TEST	=	$(addprefix source/,$(SOURCE))				\


#=========	SPECIAL VARIABLES	=========
OBJ			=	$(SRC_MAIN:%.cpp=%.o)

OBJ_TEST	=	$(SRC_TEST:%.cpp=%.o)

GCDAS		=	$(SRC_MAIN:%.cpp=%.gcda) $(SRC_TEST:%.cpp=%.gcda)
GCNOS		=	$(SRC_MAIN:%.cpp=%.gcno) $(SRC_TEST:%.cpp=%.gcno)

RM			=	rm -f

GCOVR		=	gcovr -r . --exclude tests/

ECHO		=	@echo -e

#=========	FOR POURCENTAGE	=========
NBR_SRC 	:= 	$(words $(SRC_MAIN))

N 			:= 	i
C 			= 	$(words $N)$(eval N := x $N)
ECHOP 		= 	@echo -ne "\r $(GREEN)\e[1m[`expr $C '*' 100 / $(NBR_SRC)`%]\033[0m"


#	=========	COLOR	=========
DEFAULT				=		"\033[00m"
GREEN				=		"\\033[92m"
HIGHLIGHTED			=		"\033[2;102m"
HIGHLIGHTED_R		=		"\033[2;101m"
DELETION 			=		"\033[2;103m"

#	=========	TYPO	=========
BOLD				=		"\\e[1m"
ENDEF				=		"\\033[0m"


%.o: %.cpp
	$(ECHOP) "Compiling:\e[1m" $< "\e[22m"
	$(CXX) -c -o $@ $< $(CPPFLAGS)

all: CPPFLAGS += -O3
all: $(BIN)

$(BIN): $(OBJ)
	$(ECHO) "$(BOLD)Linking...$(ENDEF)"
	$(CXX) $(OBJ) -o $(BIN)
	$(ECHO) "$(GREEN)Build exec: $(BOLD)OK$(ENDEF)"
	$(ECHO) "$(GREEN)COMPILATION SUCCEEDED$(ENDEF)"


gdb: CPPFLAGS += -g3 -O0 -ggdb3
gdb:$(BIN)
	gdb ./$(BIN)

valgrind: CPPFLAGS += -g3 -O0 -ggdb3
valgrind:$(BIN)
	valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all --leak-resolution=high -v ./$(BIN)

re:	fclean all

clean:
	$(RM) $(OBJ)
	$(RM) $(OBJ_TEST)
	@echo -e "\033[0;33mBuilded OBJ: \033[1mcleaned$(ENDEF)"

fclean: clean
	$(RM) $(BIN)
	$(RM) $(BINTEST)
	$(ECHO) "\033[0;33mExecutable: \033[1mcleaned$(ENDEF)"

.PHNOY: clean fclean re all tests_run $(BIN) $(BINTEST)
