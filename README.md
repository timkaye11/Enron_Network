Enron_Network
=============

A D3 network graph using R to manipulate data and Sinatra as a backend. 

* The 156 Enron Employees are represented in the network, with employees who sent/received 0 emails from the 156 removed. 
* Using various centrality algorithms (Betweenness, Closeness, Eigenvalue centrality, TOM, etc.), we discovered the most 'important' people at Enron. 
* These 'important' people are represented in different colors in the graph

---

You can check out an interactive version of the graph at http://enron-network.herokuapp.com/TOM



DATA REDUCTION
==============
Two files handle the brunt of the pre-analysis data reduction: ffdf_corpus_converter.r and adjacency_matrix_parsing.R. The first file, ffdf_corpus_converter.R, converts the raw Enron corpus into a more manageable data format by using the ff package in R. The latter file produces the month-binned adjacency matrices that were co-added and used in the paper.
