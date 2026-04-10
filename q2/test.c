# include <stdio.h>
# include <stdlib.h>


int main(int argc, char *argv[]){
    int n = argc - 1;

    int* arr = malloc(n * sizeof(int));
    int* result = malloc(n * sizeof(int));
    int* stack = malloc(n * sizeof(int));

    for (int i = 0; i < n; i++) {
        arr[i] = atoi(argv[i+1]);
    }

    int top = -1;
    
    for(int i = 0; i < n; i++){
        result[i] = -1;
    }

    for(int i = n-1; i >= 0; i--){
        while(top != -1 && arr[stack[top]] <= arr[i]){
            top--;
        }

        if(top != -1)result[i] = stack[top];
        top++;
        stack[top] = i;
    }

    for(int i = 0; i < n; i++){
        printf("%d ",result[i]);
    }
    printf("\n");

    return 0;
}