int ip2[5];

int gcd(int a, int b) {
  int x;
  if(b == 0) {
    return a;
  }
  x=a/b;
  return gcd(b, a-x*b);
}

int MAIN(){
  int ip1 = 5; 
  int res,i;
  int oc=0;
  ip2[0]=2;
  ip2[1]=8;
  ip2[2]=12;
  ip2[3]=32;
  ip2[4]=46;
  res=ip2[0];
  for (i = 0; i < ip1;i=i+1){ 
    res=gcd(ip2[i], res);
    }
 
  write(res);
  write("\n");
}
