# MATLAB の最適化ソルバー fmincon を使い、multiple shooting によって、宇宙探査機の軌道最適化を行うコードです。

本コードでは、2体問題の運動方程式を用い、地球ー火星遷移軌道を設計します。
この軌道は、ホーマン遷移軌道として解析的に求められる軌道があるので、それを最適化によって数値的に求めます。

## 使い方
以下のフローで、初期軌道の描画、最適化、最適軌道の描画が実行できます。
1. git clone <URL>
2. mainを実行
※ 実行時間は、MacbookAir M2 8GB で36秒でした。

※ confun内部のコメントアウトを有効にすると、最適化途中もプロットされますが、非常に時間がかかってしまうためおすすめしません。


## 最適化問題
- 推進剤消費量の最小化
- 最適化変数は、ΔV1, ΔV2, ΔV3, T1, T2

### 初期軌道
<img src="https://github.com/user-attachments/assets/5c6d528c-1940-42fc-9aaa-733f2ceb3b72" width="500" alt="image">

始点（ΔV1）、終点（ΔV3）に加え、中間インパルス（ΔV2）を加えています。

それぞれの区間の遷移時間、T1, T2も最適化変数になっています。

### 最適軌道
<img src="https://github.com/user-attachments/assets/b6610762-3920-412b-b4a1-2239ede5b93d" width="500" alt="image">

始点、終点、中間インパルスでΔVを矢印で描画しています。

中間インパルスが図示されていないように見えますが、最適化の結果、T1≒0、ΔV2≒0になっており、始点と一致しています。

### 解析的なホーマン遷移軌道のΔV
ΔV=5.593 km/sです（コードを実行すれば表示されます）

今回最適化で求めた解が、ΔV=5.538 km/s なので最適解が得られていることが分かります。

（ΔVがホーマン遷移軌道の解析解よりも小さいのは、多少の誤差かと思います）

※Qiitaで詳細な解説記事書いてるので少々お待ちください。
