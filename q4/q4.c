# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <dlfcn.h>

int main(){

    char firstbit[6] = "./lib";
    char lastbit[4] = ".so";
    char comm[6];
    int o1,o2;

    while (scanf("%s %d %d", comm, &o1, &o2) != EOF) {
        char fullcomm[20];
        int commlen = strlen(comm);

        for(int i = 0; i < 5; i++){
            fullcomm[i] = firstbit[i];
        }

        for(int i = 5; i < 5 + commlen; i++){
            fullcomm[i] = comm[i-5];
        }

        for(int i = 5+commlen; i < 8+commlen; i++){
            fullcomm[i] = lastbit[i-5-commlen];
        }
        fullcomm[8+commlen] = '\0';

        void *opener = dlopen(fullcomm, RTLD_LAZY);
        if(opener == NULL)continue;

        int (*operation)(int,int);
        operation = dlsym(opener,comm);

        if(operation != NULL){
            int res = operation(o1,o2);
            printf("%d\n",res);

        }
        
        dlclose(opener);
    }

    return 0;
}
