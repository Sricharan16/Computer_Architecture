#include<bits/stdc++.h>
using namespace std; 
#define ll long long 
string data[50001];
int numberofentries,cachecapacity;
char * filename;
fstream file;
ofstream output;
int standard;
int total_misses=0,compulsory_misses=0,capacity_misses=0;
bool findit(string key, vector<string>& temp)
{
    for (int i = 0; i < temp.size(); i++)
    {
        if (temp[i] != key)
            continue;
        else
            return 1;
    }
    return 0;
}
int LRU()
{
    unordered_set<string> s;
    unordered_set<string> x;
    unordered_map<string, int> idx;
    for (int i=0; i<numberofentries; i++)
    {
        if (s.size() < cachecapacity)
        {
            idx[data[i]] = i;
            if (s.find(data[i])==s.end())
            {
                s.insert(data[i]);
                x.insert(data[i]);
                total_misses++;
            }
        }
        else
        {
            idx[data[i]] = i;
            if (s.find(data[i]) != s.end())
            {
            //we do nothing here      
            standard=0;  
            }
            else
            {
                int lru = INT_MAX; 
                string val;
                std::unordered_set<string>::iterator it;
                for (it=s.begin(); it!=s.end(); it++)
                {
                    if  (!(idx[*it] >= lru))
                    {
                        val = *it;
                        lru = idx[*it];
                        
                    }
                }
                s.insert(data[i]);
                x.insert(data[i]);
                total_misses++;
                s.erase(val);
            }
            
        }
    }
    compulsory_misses=x.size();
    capacity_misses=total_misses-compulsory_misses;
    s.clear();
    x.clear();
    idx.clear();
    output<<"TOTAL_ACCESSES = "<<numberofentries<<"\n";
    output<<"TOTAL_MISSES = "<<total_misses<<endl;
    output<<"COMPULSORY_MISSES = "<<compulsory_misses<<endl;
    output<<"CAPACITY_MISSES = "<<capacity_misses<<"\n";
    for (int i=0; i<numberofentries; i++)
    {
        if (s.size() < cachecapacity)
        {
            idx[data[i]] = i;
            if (s.find(data[i])!=s.end())
            {
                output<<"HIT\n";
            }
            else
            {
                s.insert(data[i]);
                output<<"MISS\n";
            }
        }
        else
        {
            if (s.find(data[i]) == s.end())
            {
                int lru = INT_MAX; 
                string val;
                for (auto it=s.begin(); it!=s.end(); it++)
                {
                    if (!(idx[*it] >= lru))
                    {
                        lru = idx[*it];
                        val = *it;
                    }
                }
                s.erase(val);
                output<<"MISS\n";
                s.insert(data[i]);
            }
            else
                output<<"HIT\n";
            idx[data[i]] = i;
        }
    }
	return 0;
}
int predict(vector<string>& temp, int idx)
{
    ll res = -1;
    ll farthest = idx;
    ll i,j;
    for ( i = 0; i < temp.size(); i++) 
        {
                for (j = idx; j < numberofentries; j++) 
                {
                    if (temp[i] != data[j]) 
                    {
                        standard=0;
                        //we need not do anything here
                    }
                    else
                    {
                        if (j > farthest) {
                            farthest = j;
                            res = i;
                        }
                        break;
                    }
                }
            if (numberofentries!=j)
                {
                    //we do nothing here
                    standard=0;
                }
            else
                return i;
        }
        if(res== -1)
            return 0;
        else
            return res;
}
int FIFO()
{
    unordered_set<string> s;
    set<string> x;
    queue<string> idx;
    
    for (int i=0; i<numberofentries; i++)
    {
        if (s.size() < cachecapacity)
        {
            if (s.find(data[i])!=s.end())
            {
                //we do nothing here
                standard=0;
            }
            else
            {
                s.insert(data[i]);
                x.insert(data[i]);
                total_misses++;
                idx.push(data[i]);
            }
        }
        else
        {
            if (s.find(data[i]) != s.end())
            {
                //we do nothing here
                standard=0;
            }
            else
            {
                string val = idx.front();
                idx.pop();
                x.insert(data[i]);
                s.erase(val);
                s.insert(data[i]);
                total_misses++;
                idx.push(data[i]);
            }
        }
    }
    compulsory_misses=x.size();
    capacity_misses=total_misses-compulsory_misses;
    s.clear();
    x.clear();
    idx={};
    output<<"TOTAL_ACCESSES = "<<numberofentries<<"\n";
    output<<"TOTAL_MISSES = "<<total_misses<<endl;
    output<<"COMPULSORY_MISSES = "<<compulsory_misses<<endl;
    output<<"CAPACITY_MISSES = "<<capacity_misses<<"\n";
    for (int i=0; i<numberofentries; i++)
    {
        if (s.size() < cachecapacity)
        {
            if (s.find(data[i])!=s.end())
            {
                output<<"HIT\n";
            }
            else
            {
                s.insert(data[i]);
                output<<"MISS\n";
                idx.push(data[i]);
            }
        }
        else
        {
            if (s.find(data[i]) != s.end())
            {
                output<<"HIT\n";
            }
            else
            {
                string val = idx.front();
                idx.pop();
                output<<"MISS\n";
                s.insert(data[i]);
                s.erase(val);
                idx.push(data[i]);
            }
        }
    }
	return 0;
}
int OPTIMAL()
{
    vector<string> temp;
    int hit = 0;
    set<string> x;
    for (int i = 0; i < numberofentries; i++) 
    {
        if (findit(data[i], temp)) 
        {
            hit++;
        }
        else
        {
            x.insert(data[i]);
            if (temp.size() >= cachecapacity)
            {
                int j = predict(temp, i + 1);
                temp[j] = data[i];
            }
            else 
            {
                temp.push_back(data[i]);
            }
        }
    }
    total_misses=numberofentries-hit;
    compulsory_misses=x.size();
    capacity_misses=total_misses-compulsory_misses;
    x.clear();
    temp.clear();
    output<<"TOTAL_ACCESSES = "<<numberofentries<<"\n";
    output<<"TOTAL_MISSES = "<<total_misses<<endl;
    output<<"COMPULSORY_MISSES = "<<compulsory_misses<<endl;
    output<<"CAPACITY_MISSES = "<<capacity_misses<<"\n";
    for (int i = 0; i < numberofentries; i++) 
    {
        if (findit(data[i], temp)) 
        {
            output<<"HIT\n";
        }
        else
        {
            output<<"MISS\n";
            x.insert(data[i]);
            if (cachecapacity <= temp.size())
            {
                int j = predict( temp, i + 1);
                temp[j] = data[i];
            }
            else 
            {
                temp.push_back(data[i]);
            }
        }
    }
	return 0;
}
void processinput()
{
    string buf;
    int i=0;
    file.open(filename);
    while (file >> buf)
    {
        data[i]=buf;
        //cout<<data[i]<<endl;
        i++;
        
    }
    numberofentries=i;
}
int main(int argc, char* argv[])
{ 
	// policyname AddressSequenceFile.txt NumberOfCacheEntries
    string choice=argv[1];
    ifstream infile(argv[2]); //open the file
    string b=argv[2];
    size_t lastindex = b.find_last_of("."); 
    b = b.substr(0, lastindex); 
    string c=argv[3];
    int ch=0;
    if(choice=="LRU")
        ch=1;
    else if(choice=="OPTIMAL")
        ch=3;
    else if(choice=="FIFO")
        ch=2;
    cachecapacity=atoi(argv[3]);
  	filename = argv[2];
	output.open ("CS16BTECH11044_"+choice+"_"+b+"_"+c+".out");
    processinput();
    switch(ch)
    {
        case 1://LRU
        {
            //cout<<"THis policy";
            LRU();
            break;
        }
        case 2://FIFO
        {
            FIFO();
            break;
        }
        case 3://OPTIMAL
        {
            OPTIMAL();
            break;
        }
       default:
        {
            cout<<"Command improper";
        }
    }
    return 0;
}