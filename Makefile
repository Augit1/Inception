##########################################################
## Makefile

####################
## Rules

all:
	docker-compose -f srcs/docker-compose.yml up --build

clean:
	docker-compose -f srcs/docker-compose.yml down -v

fclean: clean
	docker-compose rm $(docker images -q) clean

re: fclean all

.PHONY: all clean fclean re
