/*TRABALHO 1 - Calculador Assembly

 Data de submissao: 11/06/2020
 * Nome: Anderson Santos Silva
 * RA:166191
 * Nome: Lucas Leite Tavares  
 * RA: 156377
 */



%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);
int inicial = 0;/*auxiliar para reset dos registradores*/
int cont_exponencial = 1;/*auxiliar para exponenciação. Caso tenhamos mais de 1 exponencial e gerarmos 2 vezes os rótulos EXP: e EXIT: travaremos o programa assembly, dessa forma geramos EXP1:, EXP2:... EXIT1:, EXIT2,...*/
%}

%token INT SOMA EOL OP MULT EXP DIV '(' ')'
%left SOMA 
%left MULT DIV
%left EXP
%left '(' ')'

%%

PROGRAMA:
/*topo da árvore, que pega o resultado das operações e atribui ao registrador A*/
        PROGRAMA EXPRESSAO EOL { printf("POP A\n");
        cont_exponencial = 1;}
        |
        ;


EXPRESSAO:
/*As regras abaixo vão verificar qual a operação que vai ser executada */
    INT{ printf("PUSH %d\n", $1);
    		if (inicial == 0){
		/*Inicialização dos registradores, para evitar que eles contenham lixo*/
		printf("\nMOV A, 0\n");
		printf("MOV B, 0\n");
		printf("MOV C, 0\n");
		printf("MOV D, 0\n");
		inicial = 1/*uma vez resetados os registradores, não precisamos mais reseta-los a não ser que recebamos nova expressão*/
		}
    }
    /*essa operação em assembly indentifica um inteiro, e o insere na pilha dessa forma quando tivermos que realizar uma operação as demais regras o retirão da pilha*/
    |'(' EXPRESSAO ')'/*Regra que garante que o que estiver entre parenteses será lido*/
    |EXPRESSAO EXP EXPRESSAO{/*Regra que identifica a operação de exponenciação*/		
    /*Comentário sobre o inicio da operação de exponenciação, para que quem leia o bloco assembly saiba qual operação será realizada*/
	printf("\n;inicio da exponenciação\n");
	printf("POP B\n");/*Retirando o expoente da pilha*/
        printf("POP C\n");/*retirando a base da exponenciação da pilha*/
        printf("MOV A, 1\n");/*as multiplicações ocorrerão em A*/
        printf("\n");
       	printf("EXP%d:\n",cont_exponencial);/*loop onde faremos a exponenciação*/
        printf("MUL C\n");
        printf("SUB B, 1\n");/*subtraindo 1 do valor do expoente, e definindo quantos produtos ainda teremos que fazer*/
	printf("CMP B, 0\n");/*comparação entre 0 e o valor de B para saber se permanecemos no loop ou não*/
        printf("JE EXIT%d\n",cont_exponencial);/*caso já tenhamos atingido o número de loops necessários B = 0, pulamos para a saída*/
        printf("JNE EXP%d\n",cont_exponencial);
        printf("EXIT%d:\n",cont_exponencial);/*Endereço da saída, onde mandamos o valor da exponenciação para a pilha*/
        printf("PUSH A\n");/*Retornando o resultado para a pilha*/
        cont_exponencial++;/*caso tenhamos nova exponencia, os rótulos serão EXP2 e EXIT2 para evitar conflitos.*/
   }
   |EXPRESSAO DIV EXPRESSAO{/*Função que identifica a operação da divisão*/
	/*Comentário sobre o inicio da operação de divisão, para que quem leia o bloco assembly saiba qual operação será realizada*/
	printf("\n;inicio da divisão\n");
       	printf("POP B\n");/*Retirando o divisor da pilha*/
        printf("POP A\n");/*Retirando o dividendo da pilha*/
        printf("DIV B\n");/*Dividindo o valor em A pelo valor de B*/
        printf("PUSH A\n");/*Retornando o resultado para a pilha*/
    }
    |EXPRESSAO MULT EXPRESSAO{/*Função que identifica a operação da multiplicação*/
		/*Comentário sobre o inicio da operação de multiplicação, para que quem leia o bloco assembly saiba qual operação será realizada*/
	printf("\n;inicio da multiplicação\n");
    	printf("POP A \n");/*Retirando o fator1 da pilha*/
        printf("POP B \n");/*Retirando o fator2 da pilha*/
        printf("MUL B\n");/*Multiplicando o valor em A por B*/
        printf("PUSH A\n");}/*Retornando o resultado para a pilha*/
	|EXPRESSAO SOMA EXPRESSAO{/*Função que identifica a operação da soma*/
	/*Comentário sobre o inicio da operação de soma, para que quem leia o bloco assembly saiba qual operação será realizada*/
	printf("\n;inicio da soma\n");
       	printf("POP C\n");/*Retirando o fator1 da pilha*/
        printf("POP B\n");/*Retirando o fator1 da pilha*/
        printf("ADD B, C\n");/*Somando os valores de B e C*/
        printf("PUSH B\n");/*Retornando o resultado para a pilha*/
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
