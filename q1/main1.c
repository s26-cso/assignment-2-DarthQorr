#include <stdio.h>
#include <stdlib.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
}Node;


extern struct Node* make_node(int val);
extern struct Node* insert(struct Node* root, int val);
extern struct Node* get(struct Node* root, int val);
extern int getAtMost(int val, struct Node* root);


struct Node* owncreate(int value){
    struct Node* newnode = malloc(sizeof(struct Node));
    newnode->val = value;
    newnode->left = NULL;
    newnode->right = NULL;

    return newnode;
}


struct Node* owninsert(struct Node* root, int value){
    if(root == NULL){
        root = owncreate(value);
        
        return root;
    }

    if(value < root->val){
        if(root->left != NULL)owninsert(root->left, value);
        else root->left = owncreate(value);
    }
    else{
        if(root->right != NULL)owninsert(root->right, value);
        else root->right = owncreate(value);
    }

    return root;
}


struct Node* ownget(struct Node* root, int value){
    if(root == NULL)return NULL;

    if(value < root->val)ownget(root->left, value);
    else if(value > root->val)ownget(root->right, value);
    else return root;
}



int owngetAtMost(int value, struct Node* root){
    if(root == NULL)return -1;

    int res = -1;

    while(root != NULL){
        if(root->val > value){
            root = root->left;
        }
        else if(res <= root->val){
            res = root->val;
            root = root->right;
        }
    }

    return res;
}


void inorder(struct Node* root) {
    if (root != NULL) {
        inorder(root->left);
        printf("%d ", root->val);
        inorder(root->right);
    }
}

int main() {
    struct Node* root = NULL;

    // root = insert(root, 10);
    // root = insert(root, 35);
    // root = insert(root, 32);
    // root = insert(root, 76);
    // root = insert(root, 53);
    // root = insert(root, 42);


    root = owninsert(root, 10);
    root = owninsert(root, 35);
    root = owninsert(root, 32);
    root = owninsert(root, 76);
    root = owninsert(root, 53);
    root = owninsert(root, 42);
    root = owninsert(root, 13);


    struct Node* a = get(root, 34);
    if(a == NULL){
        printf("NULL\n");
    }
    else printf("%d\n",a->val);

    int b = getAtMost(31, root);
    printf("%d\n",b);


    // inorder(root);







    
    // inorder(root);
    // printf("\n");

    // struct Node* found = get(root, 7);
    
    // if(found != NULL) printf("%d\n", found->val);
    // else printf("NULL");

    // int res = getAtMost(10, root); 
    // printf("   getAtMost(14): %d\n", res);

    // res = getAtMost(2, root);
    // printf("%d\n", res);

    return 0;
}