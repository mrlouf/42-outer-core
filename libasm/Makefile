NAME			= libasm.a

SRC				=	ft_strlen.s		\
				ft_strcpy.s			\
				ft_strcmp.s			\
				ft_write.s			\
				ft_read.s			\
				ft_strdup.s

SRCDIR			=	./mandatory
SRCS			=	$(addprefix $(SRCDIR)/, $(SRC))

SRC_BONUS		=	ft_atoi_base_bonus.s	\
				ft_list_push_front_bonus.s	\
				ft_list_size_bonus.s		\
				ft_list_sort_bonus.s		\
				ft_list_remove_if_bonus.s

SRCDIR_BONUS	=	./bonus
SRCS_BONUS		=	$(addprefix $(SRCDIR_BONUS)/, $(SRC_BONUS))

OBJDIR			= .obj

OBJS			= $(addprefix $(OBJDIR)/, $(SRCS:.s=.o))
OBJS_BONUS		= $(addprefix $(OBJDIR)/, $(SRCS_BONUS:.s=.o))

CFLAGS			= -Werror -Wextra -Wall -Wpedantic -g

all:	$(NAME)

bonus:	test_bonus

$(OBJDIR)/%.o:	%.s Makefile
	@mkdir -p $(@D)
	@nasm -f elf64 -g $< -o $@

$(NAME): $(OBJS) Makefile $(SRCDIR)/main.c
	@ar rcs $(NAME) $(OBJS)
	@gcc $(CFLAGS) $(SRCDIR)/main.c -L. $(OBJS) -o test

$(OBJDIR)/%_bonus.o:	%_bonus.s Makefile
	@mkdir -p $(@D)
	@nasm -f elf64 -g $< -o $@

test_bonus: $(OBJS_BONUS) Makefile $(SRCDIR_BONUS)/main_bonus.c
	@ar rcs $(NAME) $(OBJS_BONUS)
	@gcc $(CFLAGS) $(SRCDIR_BONUS)/main_bonus.c -L. $(OBJS_BONUS) -o test_bonus

clean:
	@/bin/rm -fr $(OBJDIR)

fclean:	clean
	@/bin/rm -f $(NAME) test test_bonus

re:	fclean all

.PHONY: libasm all clean fclean re bonus