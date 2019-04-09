struct token{
	int hashVal;
	char name[256];
	char type[256];
	int size;
	char scope;
	int arg;
	int args[50];
	char retType[256];
	struct token* next;
};

typedef struct token* TOKEN;

TOKEN table[20];

void initialize_symtable(){
	for(int i=0;i<20;i++)
		table[i] = NULL;
}

int compHash(char *str){

	int hashVal = 0;
	for(int i=0;i<strlen(str);i++)
		hashVal += (i+1)*(int)str[i];

	hashVal %= 20;

	//printf("\nHashVal of %s = %d", str, hashVal);
	
	return hashVal;
}

int searchVal(char name[]){

	int hash = compHash(name);
	TOKEN check = table[hash];
	while(check != NULL){
		if(strcmp(name, check->name) == 0)
			return hash;
		check = check->next;
	}

	return -1;
}

void insertToken(char name[], char type[], int size, char scope, int arg, int args[], char retType[]){

	//printf("\nInside Insert Funtion for %s\n", name);
	if(searchVal(name) != -1){
		return;
	}

	TOKEN temp = (TOKEN)malloc(sizeof(struct token));
	//printf("\nMem Alocated...\n");
	temp->hashVal = compHash(name);
	strcpy(temp->name, name);
	strcpy(temp->type, type);
	temp->size = size;
	temp->scope = scope;
	temp->arg = arg;
	for(int i=0;i<arg;i++)
		temp->args[i] = args[i];
	if(retType == NULL){
		strcpy(temp->retType, " ");
	}
	else{
		strcpy(temp->retType, retType);
	}

	//printf("Copied items into temp.\n");

	temp->next = NULL;

	//printf("Copied items into temp.\n");
	if(table[temp->hashVal] == NULL)
		table[temp->hashVal] = temp;
	else{
		TOKEN check = table[temp->hashVal];
		while(check->next != NULL)
			check = check->next;

		check->next = temp;
	}

	//printf("Done\n");
}

void displaySymTab(){

	FILE *fp;
	fp = fopen("sym_out.txt", "w");

	//printf("\n ----------------------------------------------------------------------------");
	fprintf(fp, "\nHash |  ID Name                         |  ID Type   |  Size   |  Scope  |   Arg   |   Ret Type  |");
	fprintf(fp, "\n---------------------------------------------------------------------");
	for(int i=0;i<20;i++){
		if(table[i] != NULL){
			TOKEN check = table[i];
			while(check != NULL){
				fprintf(fp,"\n%3d  |  %30s  |  %8s  |  %5d  |  %5c  |  %5d  | ", check->hashVal, check->name, check->type, check->size, check->scope, check->arg);

				//for(int j=0;j<check->arg;j++)
					//fprintf(fp, "%d", check->args[j]);

				fprintf(fp,"%s\t\t\t", check->retType);

				check = check->next;
			}
		}
	}
	//printf("\n ----------------------------------------------------------------------------");

	fclose(fp);
}