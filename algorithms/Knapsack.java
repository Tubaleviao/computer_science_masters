import java.util.ArrayList;
import java.util.Collections;

public class Knapsack{

    public static void main(String[] args){

        // Problem 1
        int[] S = new int[] {0,1,2}; // id's
        int[] v = new int[] {2,2,3}; // values
        int[] w = new int[] {1,2,4}; // weights
        int W = 4; // total weight
        
        Knapsack kp = new Knapsack();
        ArrayList<Obj> resp = kp.knapsack(S,v,w,W);
        System.out.println("Correct Answer: ");
        resp.forEach(r -> System.out.print(r.getId()+", "));
        System.out.println(""); 
        // Answer: 0,1 (total weight: 3, total value: 4)

        // Problem 2-1: sorting by weight
        int[] S1 = new int[] {0,1,2}; // id's
        int[] v1 = new int[] {1,1,4}; // invented values
        int[] w1 = new int[] {1,2,4}; // weights
        int W1 = 4;

        ArrayList<Obj> resp1 = kp.p21(S1,v1,w1,W1);
        System.out.println("Answer p2-1: ");
        resp1.forEach(r -> System.out.print(r.getId()+", "));
        System.out.println(""); 
        // Answer: 0,1 (total weight: 3, total value: 2)
        // We can see for this case that the best option
        // should be: 2 (total weight: 4, total value: 4)
        // so this is the wrong approach.

        // Problem 2-2: sorting by value
        int[] S2 = new int[] {0,1,2}; // id's
        int[] v2 = new int[] {2,2,3}; // invented values
        int[] w2 = new int[] {1,2,4}; // weights
        int W2 = 4;

        ArrayList<Obj> resp2 = kp.p22(S2,v2,w2,W2);
        System.out.println("Answer p2-2: ");
        resp2.forEach(r -> System.out.print(r.getId()+", "));
        System.out.println(""); 
        // Answer: 2 (total weight: 4, total value: 3)
        // We can see for this case that the best option
        // should be: 0,1 (total weight: 3, total value: 4)
        // so this is the wrong approach.

        // Problem 2-3: sorting by value / weight
        int[] S3 = new int[] {0,1,2}; // id's
        int[] v3 = new int[] {1,2,4}; // invented values
        int[] w3 = new int[] {1,2,3}; // invented weights
        int W3 = 4;

        ArrayList<Obj> resp3 = kp.p23(S3,v3,w3,W3);
        System.out.println("Answer p2-3: ");
        resp3.forEach(r -> System.out.print(r.getId()+", "));
        System.out.println(""); 
        // Answer: 0,1 (total weight: 3, total value: 3)
        // We can see for this case that the best option
        // should be: 0,2 (total weight: 4, total value: 4)
        // so this is the wrong approach.

        // Problem 3-1: Yes, it is possible but not in every case.
        // I may not use (Sn-1) if this item has a huge weight and a low value
        
        // Problem 3-2: Yes, the new list would be the new answer
        // since the new weight W' had subtracted the item's weight.
    }

    private ArrayList<Obj> p23(int[] S, int[] v, int[] w, int W){
        int tweight = 0;
        ArrayList<Obj> all = new ArrayList<>();
        ArrayList<Obj> res = new ArrayList<>();

        for(int i=0; i<S.length; i++){
            all.add(new Obj(S[i], v[i], w[i])); 
        }

        Collections.sort(all, (a,b) -> {
            return (a.getValue()/a.getWeight())
                    -(b.getValue()/b.getWeight()); // by value / weight
        });
        
        for(int i=0; i<all.size(); i++){
            int val = all.get(i).getWeight(); 
            if(val + tweight <= W){
                Obj item = all.get(i);
                res.add(item);
                tweight += val;
            }
        }

        return res; 
    }

    private ArrayList<Obj> p22(int[] S, int[] v, int[] w, int W){
        int tweight = 0;
        ArrayList<Obj> all = new ArrayList<>();
        ArrayList<Obj> res = new ArrayList<>();

        for(int i=0; i<S.length; i++){
            all.add(new Obj(S[i], v[i], w[i])); 
        }

        Collections.sort(all, (a,b) -> {
            return b.getValue()-a.getValue(); // by value decreasing
        });
        
        for(int i=0; i<all.size(); i++){
            int val = all.get(i).getWeight(); 
            if(val + tweight <= W){
                Obj item = all.get(i);
                res.add(item);
                tweight += val;
            }
        }

        return res; 
    }

    private ArrayList<Obj> p21(int[] S, int[] v, int[] w, int W){
        int tweight = 0;
        ArrayList<Obj> all = new ArrayList<>();
        ArrayList<Obj> res = new ArrayList<>();

        for(int i=0; i<S.length; i++){
            all.add(new Obj(S[i], v[i], w[i])); 
        }

        Collections.sort(all, (a,b) -> {
            return a.getWeight()-b.getWeight(); // by weight
        });
        
        for(int i=0; i<all.size(); i++){
            int val = all.get(i).getWeight(); 
            if(val + tweight <= W){
                Obj item = all.get(i);
                res.add(item);
                tweight += val;
            }
        }

        return res; 
    }

    private ArrayList<Obj> knapsack(int[] S, int[] v, int[] w, int W){
        int tweight = 0;
        ArrayList<Obj> all = new ArrayList<>();
        ArrayList<Obj> res = new ArrayList<>();

        for(int i=0; i<S.length; i++){
            all.add(new Obj(S[i], v[i], w[i])); // create object list
        }

        Collections.sort(all, (a,b) -> {
            int order = b.getValue()-a.getValue(); // sort by value descending
            if(order == 0){
                order = a.getWeight()-b.getWeight(); // sort by weight 
            }
            return order; 
        });
        
        for(int i=0; i<all.size(); i++){
            int thisWeight = all.get(i).getWeight(); // add largest ones
            if(thisWeight + tweight <= W){
                Obj item = all.get(i);
                res.add(item);
                tweight += thisWeight;
            }else if(i+1 < all.size()){
                // remove the last item if the current + next has together
                // a lower or equal weigth and a bigger value
                int thisValue = all.get(i).getValue();
                int nextValue = all.get(i+1).getValue();
                int lastValue = all.get(i-1).getValue();
                int nextWeight = all.get(i+1).getWeight();
                int lastWeight = all.get(i-1).getWeight();
                if(thisWeight + nextWeight <= lastWeight && 
                    thisValue + nextValue > lastValue){
                        Obj removed = res.remove(i-1);
                        tweight -= removed.getWeight();
                        Obj item = all.get(i);
                        res.add(item);
                        tweight += thisWeight;
                    }
            }
        }

        return res; // return most valuable items less than W
    }
}