#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

// Declaring the asm functions as extern for the C compiler
extern size_t	ft_strlen(char const *s);
extern char*	ft_strcpy(char *dest, char const *src);
extern int		ft_strcmp(char const *s1, char const *s2);
extern ssize_t	ft_write(int fd, const void *buf, size_t count);
extern ssize_t	ft_read(int fd, void *buf, size_t count);
extern char*	ft_strdup(char const *s);

// bonus functions
extern int		ft_atoi_base(char const *str, char const *base);
extern void 	ft_list_push_front(void **begin_list, void *data);
extern int		ft_list_size(void *begin_list);
extern void 	ft_list_sort(void **begin_list, int (*cmp)());
extern void 	ft_list_remove_if(void **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)());

char const		*s1 = "Hello";
char			s2[20] = "World!";
char const		*s3 = NULL;


int	main()
{
 	{
		printf("Testing strlen:\n");
		printf("%lu\n", ft_strlen(""));
		printf("%lu\n", strlen(""));
		printf("%lu\n", ft_strlen(s1));
		printf("%lu\n", strlen(s1));
		printf("\n");
	}
	{
		printf("Testing strcpy:\n");
		//printf("%s\n", ft_strcpy("", ""));
		//printf("%s\n", strcpy("", ""));
		printf("%s\n", ft_strcpy(s2, s1));
		printf("%s\n", strcpy(s2, s1));
		//printf("%s\n", ft_strcpy(s2, s3));
		//printf("%s\n", strcpy(s2, s3));
		printf("\n");
	}
	{
		struct {
			const char *a;
			const char *b;
		} tests[] = {
			{"", ""},
			{"A", ""},
			{"", "A"},
			{"A", "A"},
			{"ABC", "ABC"},
			{"ABC", "ABD"},
			{"ABD", "ABC"},
			{"ABC", "ABA"},
			{"ABA", "ABC"},
			{"Hello", "Hello"},
			{"Hello", "Hellp"},
			{"Hellp", "Hello"},
			{"Hello", "Hell"},
			{"Hell", "Hello"},
			{"", "abc"},
			{"abc", ""},
			{"abc", "abc"},
			{"abc", "abd"},
			{"abd", "abc"},
			{NULL, NULL}
		};

		for (int i = 0; tests[i].a != NULL; i++) {
			int std = strcmp(tests[i].a, tests[i].b);
			int ft = ft_strcmp(tests[i].a, tests[i].b);
			printf("Test %2d: ft_strcmp(\"%s\", \"%s\") = %d | strcmp = %d\n",
				i, tests[i].a, tests[i].b, ft, std);
		}
		printf("\n");
	}
	{
		printf("Testing write:\n");
		ft_write(1, "Hello, World!\n", 14);
		write(1, "Hello, World!\n", 14);
		ft_write(1, "This is a test of ft_write.\n", 10);
		ft_write(1, "\n", 1);
		write(1, "This is a test of write.\n", 10);
		ft_write(1, "\n", 1);
		ft_write(42, "This should fail and print nothing.\n", 38);
		write(42, "This should also fail and print nothing.\n", 42);
		ft_write(1, "", 0);
		write(1, "", 0);

		printf("\n");
	}
	{
		char buffer[100];
		ssize_t bytesRead;

 		ft_write(1, "Testing read:\n", 15);
		ft_write(1, "Enter some text: ", 17);
		bytesRead = ft_read(0, buffer, sizeof(buffer) - 1);
		if (bytesRead < 0) {
			ft_write(1, "Error reading input.\n", 22);
		} else {
			buffer[bytesRead] = '\0'; // Null-terminate the string
			ft_write(1, "You entered: ", 13);
			const ssize_t res = ft_write(1, buffer, bytesRead);
			ft_write(1, "\n", 1);
			printf("bytesRead: %zd\n", bytesRead);
			printf("ft_write returned: %zd\n", res);
			ft_write(1, "\n", 1);
		}

		ft_write(1, "Testing ft_read with invalid file descriptor:\n", 48);
		bytesRead = ft_read(42, buffer, sizeof(buffer) - 1);
		if (bytesRead < 0) {
			ft_write(1, "Error reading from invalid file descriptor: ", 45);
			printf("errno code: %zd\n", bytesRead);
		} else {
			buffer[bytesRead] = '\0'; // Null-terminate the string
			ft_write(1, "You entered: ", 13);
			const ssize_t res = ft_write(1, buffer, bytesRead);
			ft_write(1, "\n", 1);
			printf("bytesRead: %zd\n", bytesRead);
			printf("ft_write returned: %zd\n", res);
		}
		ft_write(1, "\n", 1);
	}
	{
		char *dup = ft_strdup("Hello, World!");
		if (dup) {
			ft_write(1, "Duplicated string: ", 19);
			printf("'%s'\n", dup);
			ft_write(1, "\n", 1);
			free(dup);
			dup = NULL;
		} else {
			ft_write(1, "Error duplicating string.\n", 27);
		}
		dup = ft_strdup(s1);
		if (dup) {
			ft_write(1, "Duplicated string: ", 19);
			printf("'%s'\n", dup);
			ft_write(1, "\n", 1);
			free(dup);
			dup = NULL;
		} else {
			ft_write(1, "Error duplicating string.\n", 27);
		}
		dup = ft_strdup("");
		if (dup) {
			ft_write(1, "Duplicated string: ", 19);
			printf("'%s'\n", dup);
			ft_write(1, "\n", 1);
			free(dup);
			dup = NULL;
		} else {
			ft_write(1, "Error duplicating string.\n", 27);
		}
	}
}