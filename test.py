from sklearn import metrics
labels_true = [0, 0, 0, 1, 1, 1]
labels_pred = [1, 1, 0, 0, 3, 3]

nmi = metrics.normalized_mutual_info_score(labels_true, labels_pred)