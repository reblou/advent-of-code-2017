#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int dimension(int upto);
void printGrid(int *g, int d);
struct coord traverseGrid(int *g, int d, int count);
int sumAdj(int *g, int d, int x, int y);

#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define MAX(a, b) (((a) > (b)) ? (a) : (b))

struct coord {
    int x;
    int y;
};

void printArr(int *s, int d)
{
    int i;
    for (i = 0; i < d; i++) {
        printf("%d, ", *(s+i));
    }
    printf("\n");

}

int main(int argc, char *argv[])
{
    //printf("%d\n", atoi(argv[1]));
    //printf("%lf\n", pow(2.0, 2.0));

    //printf("%d\n", dimension(atoi(argv[1])));
    //int d = dimension(atoi(argv[1]));
    int d = dimension(265149);
    int grid[d][d];
    int i, n;
    for (i = 0; i < d; i++) {
        for(n = 0; n < d; n++) {
            grid[i][n] = 0;
        }
    }
    int center = d/ 2;
    //printf("center: %d\n", center);

    grid[center][center] = 1;
    //printf("center: %d\n", grid[center][center]);

    //printGrid(grid, d);
    //printf("sum start: %d\n", sumAdj(grid, d, center, center));
    /*
    int a[] = {1,5,3,2,7,8,1,9};
    printArr(a, 8);
    */
    traverseGrid(grid, d, 265149);
}

int dimension(int upto)
{
    double start = 1;
    double i;
    int rings = 0;

    do {
        i = pow(start, (double) 2);
        start+=2;
        rings++;
    } while (i < upto);

    return rings * 2 - 1;
}

void printGrid(int *g, int d)
{
    int i, n;

    for (i = 0; i < d; i++) {
        for (n=0; n < d; n++) {
            printf("%d ", g[n * d + i]);
        }
        printf("\n");
    }
}

int sumAdj(int *g, int d, int x, int y)
{
    int sum = 0;
    int i, n;
    int a;
    int istart = MAX(y-1, 0);
    int ilim = MIN(y+1, d-1);
    int nstart = MAX(x-1, 0);
    int nlim = MIN(x+1, d-1);

    //printf("\n");
    //printGrid(g, d);
    //printf("sumadj checking (%d, %d)\n", x, y);
    for (i = istart; i <= ilim; i++) {
        for (n= nstart; n <= nlim; n++) {
            a = g[n * d + i];
            //printf("-n: %d, i: %d\n", n, i);
            //printf("-adding to sum: %d\n", a);
            sum += a;
        }
    }
    return sum;
}

struct coord traverseGrid(int *g, int d, int count)
{
    struct coord start = {d/2, d/2};
    if (count < 1 ) return start;
    struct coord current = {start.x, start.y};
    int ring = 1;
    int rings = d/2 + 1;
    int lim;
    int res = 1;
    int upLeft = 1;

    while (res <= count) {
        lim = rings - ring;
        if (lim < 0) {
            break;
        }
        if (upLeft) {
            if (current.y > lim) {
                //printf("1\n");
                current.y--;
            } else if (current.x > lim) {
                //printf("2\n");
                current.x--;
            } else {
                upLeft = 0;
            }
        }
        if (!upLeft) {
            if (current.y < d - lim -1) {
                //printf("3\n");
                current.y++;
            } else if (current.x < d-lim-1) {
                //printf("5\n");
                current.x++;
            } else {
                current.x++;
                ring++;
                upLeft = 1;
            }
        }
        //printf("x: %d, y: %d, lim: %d\n", current.x, current.y, lim);
        res = sumAdj(g, d, current.x, current.y);
        //printf("sumadj: %d\n", res);
        g[current.x * d + current.y] = res;
        //printf("________\n");
    }

    //printGrid(g, d);
    printf("res: %d\n", res);
}
