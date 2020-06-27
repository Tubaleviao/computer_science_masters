public class Obj{

    int id;
    int value;
    int weight;

    public Obj(int id, int value, int weight){
        this.id = id;
        this.value = value;
        this.weight = weight;
    }

    public void setId(int id){this.id = id;}
    public void setValue(int v){this.value = v;}
    public void setWeight(int w){this.weight = w;}

    public int getId(){return this.id;}
    public int getValue(){return this.value;}
    public int getWeight(){return this.weight;}
}