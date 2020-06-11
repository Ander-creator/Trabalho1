%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);

%}

%token INT SOMA EOL MULT EXP DIV '(' ')'
%left SOMA 
%left MULT DIV
%left EXP
%left '(' ')'

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL { printf("Resultado: %d\n\n", $2);
        						 printf("MOV A, %d\n", $2); }
        |
        ;


EXPRESSAO:
    INT { $$ = $1;}
    | '(' EXPRESSAO ')'{
		printf("Encontrei expressão entre parenteses\n\n");
		$$ = $2;}

	| EXPRESSAO EXP EXPRESSAO{
		printf("Encontrei  exponenciação: %d ^ %d\n\n", $1, $3);
		//int i = 0, cont = 1;		
		//for(i; i<$3; i++)cont = $1 *cont;
		//printf(" = %d\n", cont);
		//$$ = cont;
		
		printf("MOV A, %d\n", $1);
        printf("MOV B, %d\n", $3);
       	
        printf("EXP:\n");
        printf("MUL A\n");
        printf("SUB B, 1\n");
        printf("JE EXIT\n");
        printf("JNE EXP\n");
        printf("\n");
        printf("EXIT:\n");
        //printf("PUSH A\n");
        printf("MOV A, 0\n");
        printf("\n");
		
	}
    | EXPRESSAO MULT EXPRESSAO{
    	printf("Encontrei produto: %d * %d = %d\n\n", $1, $3, $1*$3);
    	
    	printf("MOV A %d\n", $1);
        printf("MOV B %d\n", $3);
        printf("MUL B\n");
        //printf("PUSH A\n");
        // printf("ADD D, 1\n");
        printf("MOV A, 0\n");
    	
    	$$ = $1*$3;
    	}
    | EXPRESSAO DIV EXPRESSAO{
    	//printf("Encontrei divisao: %d / %d = %d\n", $1, $3, $1/$3);
    	$$ = $1/$3;
    	
    	printf("MOV A %d\n", $1);
        printf("MOV B %d\n", $3);
        printf("DIV B\n");
        //printf("PUSH A\n");
        //printf("ADD D, 1\n");
        printf("MOV A, 0\n");
    	
    	}
    | EXPRESSAO SOMA EXPRESSAO{
        printf("Encontrei soma: %d + %d = %d\n", $1, $3, $1+$3);
        printf("MOV C, %d\n", $1);
        printf("ADD C, %d\n", $3);
        //printf("PUSH C\n");
        //printf("ADD D, 1\n");
        $$ = $1+$3;
        }

	;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  yyparse();
  return 0;

}
