# useful links

- [Ansible in RHEL](https://sysnet4admin.blogspot.kr/2017/06/ansible-rhel-72.html#.WXcGgYTyipo)
- [Ansible Definition](https://brunch.co.kr/@jiseon3169ubie/2)
- [Go Lang - Programming](http://golang.site/go/article/8-Go-%EB%B0%98%EB%B3%B5%EB%AC%B8)
- [Docker for beginner](https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)
- [python bible](https://docs.python.org/2/library/math.html)
- [Data Mining : Web-R v2.0 beta](http://web-r.org/)
- [Word Cloud](https://www.jasondavies.com/wordcloud/)
- [SVM with polynomial kernel visualization](https://youtu.be/3liCbRZPrZA)
- [bayesian example](http://j1w2k3.tistory.com/1009)

## python snippets

### nvidia gpu mode change

```bash
## 0 default
## 1 Exclusive Thread
## 2 Prohibited
## 3 Exclusive Process
nvidia-smi -i ${GPU_ID} -c ${MODE_ID}
```

### command search

```python
## dir finding
print('\n'.join([s for s in dir(np) if s.find('_c') >= 0]))

## module reload
from imp import reload

## for training
from tqdm import trange
t = trange(num_epochs)
t.set_description('epoch %i'%epoch)
t.set_postfix(train_loss = avg_train_loss, val_loss = avg_val_loss)
time.sleep(0.01)

## graph option
import matplotlib.pyplot as plt
import seaborn as sns
colors = ['#34495e','#2ecc71','#3498db','#FFFF00', '#e74c3c','#a9a9a9']
sns.set(style="ticks", color_codes=True)
plt.style.use('seaborn-darkgrid')

## get index from list by condition
def indices(list, filtr=lambda x: bool(x)):
  return [i for i,x in enumerate(list) if filtr(x)]
```


## Docker configuration

### install the docker enginer through curl

```bash
curl -fsSL https://get.docker.com >> docker.sh
sudo sh ./docker.sh
```
