#################################################
#              Text Filtering by Keywords          #
#################################################

shinyServer(function(input, output,session) {
  set.seed=2092014   

text <- reactive({
    if (is.null(input$file)) {return(NULL)}
      else {
        document = readLines(input$file$datapath)
        return(document)}
      })

wordlist <- reactive({
  if (is.null(input$keywords)) {key1 = ""} else {
    key1 = readLines(input$keywords$datapath)
  }
  if (input$keywords2 == "") {key2 = ""} else {
    key2 = unlist(strsplit(input$keywords2,","))
  }
  key = setdiff(unique(c(key1,key2)),"")
  return(key)
})


arbit_wl = reactive({
  arbit_wl = wordlist() %>% data_frame()
  colnames(arbit_wl) = "word"
  arbit_wl
  
})


sentence = reactive({
  arbit_wl = arbit_wl()
  pred.an = text()
  pred.an1 = pred.an[(pred.an != "")] %>% data_frame()
  colnames(pred.an1)= "text"

  pred.an2 = pred.an1 %>% unnest_tokens(sentence, text, token = "sentences")

  a0 = pred.an2 %>%

    # setup a sentence index for later reference
    mutate(sent1 = seq(1:nrow(pred.an2))) %>% dplyr::select(sent1, sentence) %>%

    # tokenize words in each sentence usng group_by
    group_by(sentence) %>% unnest_tokens(word, sentence) %>% ungroup() %>%

    # now merge wordlists
    inner_join(arbit_wl, by = "word") %>%

    # de-duplicate sentence index
    dplyr::select(sent1) %>% unique()

  # filter corpus based on sentence list
  pred.an3 = pred.an2 %>%
    # sentence index construction
    mutate(sent1 = seq(1:nrow(pred.an2))) %>% dplyr::select(sent1, sentence) %>%

    # inner join and retain selected sents only
    inner_join(a0, by = "sent1") %>% dplyr::select(sentence, sent1)

  pred.an3 = data.frame(pred.an3)
  sentence = pred.an3$sentence
  return(sentence)
  })

output$filter_corp = renderPrint({
cat("Total ", length(sentence())," sentences.\n")
cat(as.String(paste0(1:length(sentence())," -> ", sentence())))
})

output$downloadData1 <- downloadHandler(
    filename = function() { "Nokia_Lumia_reviews.txt" },
    content = function(file) {
      writeLines(readLines("data/Nokia_Lumia_reviews.txt"), file)
    }
  )


output$downloadData2 <- downloadHandler(
  filename = function() { "Keywords.txt" },
  content = function(file) {
    writeLines(readLines("data/keywords.txt"), file)
  }
)


output$downloadData3 <- downloadHandler(
  filename = function() { "Filtered_corpus.txt" },
  content = function(file) {
    writeLines(sentence(), file)
  }
)

})
