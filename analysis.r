library(jsonlite)
library(tidyverse)
library(rwebppl)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

base = 6
expand = 4

code <- read_file("model_code")
code_morealts <- read_file("model_code_morealts")

eval_webppl <- function(command) {
  webppl(paste(code,command,sep="\n"))
}

eval_webppl_morealts <- function(command) {
  webppl(paste(code_morealts,command,sep="\n"))
}

standard_anyqud <- eval_webppl("impSpeaker(9,1,0,nohalos)")
pt_anyqud_9_nohalo <- eval_webppl("impSpeaker(9,1,0.5,nohalos)")
pt_anyqud_4_nohalo <- eval_webppl("impSpeaker(4,1,0.5,nohalos)")
pt_anyqud_4_yeshalo <- eval_webppl("impSpeaker(4,1,0.5,yeshalos)")
pt_anyqud_9_yeshalo <- eval_webppl("impSpeaker(9,1,0.5,yeshalos)")
pt_listener_9_yeshalo <- eval_webppl("pragmaticListener('the',1,0.5,yeshalos)")
pt_listener_9_yeshalo_morealts <- eval_webppl_morealts("pragmaticListener('the',1,0.5,yeshalos)")

partialtruth_most <- eval_webppl("partialTruth('most')")
partialtruth_some <- eval_webppl("partialTruth('some')")

graph <- function(data) {
  
  data$prob <- as.numeric(data$prob)
  data$support <-  ordered(data$support, levels = c("none", "some", "most", "the", "all"))
  levels(data$support) <- c("none\n-asleep", "some\n-asleep", "most\n-asleep", "the\n-asleep", "all\n-asleep")
  
  p <- data %>%
    #arrange(x) %>%
    ggplot(aes(x=support,y=prob)) +
    theme_bw() +
    theme(text = element_text(size = base * expand / 2, face = "bold")) +
    geom_bar(stat="identity",position = "dodge") +
    xlab("Utterance") +
    ylab("Probability") 
  
  return(p)
  
}

graph(standard_anyqud) 
ggsave("Fig1-precise.pdf", width = 3, height = 2, units = "in")

graph(partialtruth_most)
ggsave("Fig2a-pt-most.pdf", width = 3, height = 2, units = "in")

graph(partialtruth_some)
ggsave("Fig2b-pt-some.pdf", width = 3, height = 2, units = "in")

graph(pt_anyqud_9_nohalo) + ylim(0,0.7)
ggsave("Fig3a-pt-anyqud-9-nohalo.pdf", width = 3, height = 2, units = "in")

graph(pt_anyqud_4_nohalo) + ylim(0,0.7)
ggsave("Fig3b-pt-anyqud-4-nohalo.pdf", width = 3, height = 2, units = "in")

graph(pt_anyqud_9_yeshalo) + ylim(0,1)
ggsave("Fig4a-pt-anyqud-9-yeshalo.pdf", width = 3, height = 2, units = "in")

graph(pt_anyqud_4_yeshalo) + ylim(0,1)
ggsave("Fig4b-pt-anyqud-4-yeshalo.pdf", width = 3, height = 2, units = "in")

graph_listener <- function(data) {
  
  data$prob <- as.numeric(data$prob)
  data$support <-  factor(data$support)
  labels = c(expression(m[1]), 
             expression(m[2]), expression(m[3]), 
             expression(m[4]), expression(m[5]), 
             expression(m[6]), expression(m[7]),
             expression(m[8]), expression(m[9]),
             expression(m[10]))
  
  p <- data %>%
    #arrange(x) %>%
    ggplot(aes(x=support,y=prob)) +
    theme_bw() +
    theme(text = element_text(size = base * expand / 2, face = "bold")) +
    geom_bar(stat="identity",position = "dodge") +
    xlab("Meaning") +
    ylab("Probability") +
    scale_x_discrete(labels = parse(text = labels))
  
  return(p)
  
}

p <- graph_listener(pt_listener_9_yeshalo) 
p
ggsave("Fig5-impreciselistener.pdf", width = 4, height = 2, units = "in")

p <- graph_listener(pt_listener_9_yeshalo_morealts) 
p
ggsave("Fig6-impreciselistener-morealts.pdf", width = 4, height = 2, units = "in")

# FOOTNOTE 11, showing that 'tails' of the imprecise distribution have different shapes and are differently affected by (and highly sensitive to) alpha and beta values. 

code_numeralalts <- read_file("model_numerals")
eval_webppl_numeralalts <- function(command) {
  webppl(paste(code_numeralalts ,command,sep="\n"))
}
pt_speaker_5_nohalo_morealts <- eval_webppl_numeralalts("impSpeaker(5,2,3,nohalos)")
pt_speaker_5_nohalo_morealts %>% 
  mutate(support = ordered(support, levels = c("one","two","three","four","five","six","seven","eight","nine","ten"))) %>%
  ggplot(aes(x=support,y=prob)) +
  theme_bw() +
  theme(text = element_text(size = base * expand / 2, face = "bold")) +
  geom_bar(stat="identity",position = "dodge") +
  xlab("Utterance") +
  ylab("Probability") 
