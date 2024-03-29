grammar main;

/* ---------- Imports ---------- */

@header { 
    import java.util.HashMap;
}

/* ---------- Declaraciones parser ---------- */

@members { 
    HashMap tablaDeSimbolos = new HashMap();
}

/* ------------------------------ Reglas ------------------------------ */

// Inicial
init: mod_acceso CLASS ID LLAVEA (metodo | atributo)* LLAVEC;

// Atributo
atributo: mod_acceso? tipo ID (COMA ID)* PUNTOYCOMA;

// Metodo
metodo:
	mod_acceso? directiva? tipo ID PARA decl_args? PARC LLAVEA sentencia* LLAVEC;

// declaración de argumentos
decl_args: tipo ID (COMA tipo ID)*;

// declaración de argumentos
decl_local: tipo ID (COMA ID)* PUNTOYCOMA;

// sentencia
sentencia: asignacion | decl_local;

// asignacion
asignacion: ID OPASIGN expr PUNTOYCOMA;

// expresion
expr: multExpr ((OPMAS | OPMENOS) multExpr)*;

// expresion multiplicación
multExpr: atom ((OPMULT | OPDIV) atom)*;

// atomo
atom: ID | CINT | CFLOAT | PARA expr PARC;

id:
	ID {
            Integer obj = (Integer) tablaDeSimbolos.get($ID.text);
            if (obj==null){
                Integer objNuevo = Integer.valueOf(1);
                tablaDeSimbolos.put($ID.text, objNuevo); //hace put a la tabla de simbolos y tengo que asignarle una clave y un valor
                }
            else{ obj=obj.intValue()+1;
                tablaDeSimbolos.put($ID.text,obj);
                }

        };
end:
	END {
            for (Object key : tablaDeSimbolos.keySet()) {
                Object value = tablaDeSimbolos.get(key);
                System.out.println("El elemento \"" + key + "\" se repite: " + value + " veces");
            }
        };

mod_acceso: PUBLIC | PRIVATE | PROTECTED;
tipo: STRING | INT | FLOAT | DOUBLE | BOOLEAN | CHAR | VOID;
directiva: STATIC;
pals_reservadas: MAIN | SYSTEM | OUT | PRINTLN | IN;
ops_aritmeticos: OPMAS | OPMENOS | OPDIV | OPMULT;
op_asignacion: IGUALASIG;
puntuacion: PUNTO | PUNTOYCOMA | COMA;
ops_agrupacion: PARA | PARC | LLAVEA | LLAVEC | CORCHA | CORCHC;
ops_relacionales:
	MAYOR
	| MENOR
	| IGUALCOMP
	| DIFERENTE
	| MAYOROIGUAL
	| MENOROIGUAL;
constantes:
	CINT
	| CFLOAT
	| CSTRING
	| CCHAR {
            System.out.println("Constante caracter detectado: " + $CCHAR.text);
            };

/* ------------------------------ Tokens ------------------------------ */

// ops_relacionales:
MAYOR: '>';
MENOR: '<';
IGUALCOMP: '==';
DIFERENTE: '=!';
MAYOROIGUAL: '>=';
MENOROIGUAL: '<=';

// op_asignacion:
IGUALASIG: '=';

// puntuacion:
PUNTO: '.';
PUNTOYCOMA: ';';
COMA: ',';

// ops_agrupacion:
PARA: '(';
PARC: ')';
LLAVEA: '{';
LLAVEC: '}';
CORCHA: '[';
CORCHC: ']';

OPMAS: '+';
OPMENOS: '-';
OPDIV: '/';
OPMULT: '*';

MAIN: 'main';
SYSTEM: 'System';
OUT: 'out';
PRINTLN: 'println';
IN: 'in';

STATIC: 'static';

STRING: 'String';
INT: 'int';
FLOAT: 'float';
DOUBLE: 'double';
BOOLEAN: 'boolean';
CHAR: 'char';
VOID: 'void';

PUBLIC: 'public';
PRIVATE: 'private';
PROTECTED: 'protected';
CLASS: 'class';

CFLOAT: ('0' ..'9')+ '.' ('0' ..'9')+;
CINT: ('0' ..'9')+;
CCHAR: '\'' (' ' ..'z') '\'';
CSTRING: '\"' (' ' ..'!' | '#' ..'z')+ '\"';

END: 'e' 'n' 'd';
ID: ('a' ..'z' | 'A' ..'Z' | '_') (
		'a' ..'z'
		| 'A' ..'Z'
		| '_'
		| '0' ..'9'
	)*;
WS: (' ' | '\n' | '\t' | '\r')+ { $channel=HIDDEN; };