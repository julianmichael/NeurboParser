curr_dir=`dirname $0`
mkdir -p model
mkdir -p log
mkdir -p prediction

train_epochs=100
pruner_epochs=1
lemma_dim=25
word_dim=100
pos_dim=25
mlp_dim=100
lstm_dim=200
num_lstm_layers=2
use_pretrained_embedding=true

trainer="adadelta"

use_word_dropout=true
word_dropout_rate=0.25

srl_train_cost_false_positives=0.05
srl_train_cost_false_negatives=0.95

parser_file=${curr_dir}/build/neurboparser
file_pretrained_embedding=${curr_dir}/../embedding/glove.100.qamr.pruned

file_train=${curr_dir}/../qamr_data/train_small.sdp
file_dev=${curr_dir}/../qamr_data/train_small.sdp
file_test=${curr_dir}/../qamr_data/test.sdp
file_model=${curr_dir}/model/qamr.${trainer}.lstm${lstm_dim}.layer${num_lstm_layers}.h${mlp_dim}.drop${word_dropout_rate}.model
file_pruner_model=${curr_dir}/model/qamr.pruner.model
file_prediction=${curr_dir}/prediction/qamr.${trainer}.lstm${lstm_dim}.layer${num_lstm_layers}.h${mlp_dim}.drop${word_dropout_rate}.pred
log_file=${curr_dir}/log/qamr.${trainer}.lstm${lstm_dim}.layer${num_lstm_layers}.h${mlp_dim}.drop${word_dropout_rate}.log

nohup \
${parser_file} --train  --evaluate \
--dynet_mem 512 \
--dynet_seed 823632965 \
--dynet_weight_decay 1e-6 \
--train_epochs=${train_epochs}  \
--pruner_epochs=${pruner_epochs} \
--file_train=${file_train} \
--file_test=${file_dev} \
--srl_labeled=true \
--srl_deterministic_labels=true \
--srl_use_dependency_syntactic_features=false \
--srl_prune_labels_with_senses=false \
--srl_prune_labels=true \
--srl_prune_distances=true \
--srl_prune_basic=true \
--srl_train_pruner=true \
--srl_file_pruner_model=${file_pruner_model} \
--srl_pruner_posterior_threshold=0.0001 \
--srl_pruner_max_arguments=20 \
--form_case_sensitive=false \
--srl_model_type=af \
--srl_allow_self_loops=false \
--srl_allow_root_predicate=true \
--srl_allow_unseen_predicates=false \
--srl_use_predicate_senses=false \
--srl_file_format=sdp \
--use_pretrained_embedding=${use_pretrained_embedding} \
--file_pretrained_embedding=${file_pretrained_embedding} \
--lemma_dim=${lemma_dim} \
--word_dim=${word_dim} \
--pos_dim=${pos_dim} \
--lstm_dim=${lstm_dim} \
--mlp_dim=${mlp_dim} \
--num_lstm_layers=${num_lstm_layers} \
--use_word_dropout=${use_word_dropout} \
--word_dropout_rate=${word_dropout_rate} \
--trainer=${trainer} \
--srl_train_cost_false_positives=${srl_train_cost_false_positives} \
--srl_train_cost_false_negatives=${srl_train_cost_false_negatives} \
--logtostderr \
--file_model=${file_model} \
--file_prediction=${file_prediction} \
> ${log_file} &

