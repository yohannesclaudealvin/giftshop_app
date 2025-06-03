library(shiny)
library(shinythemes)
library(shinyWidgets)
library(DT)

# Sample product data (expand this for more products)
products <- data.frame(
  Name = c("Rose Teddy", "Customized Mug", "LED Frame"),
  Description = c("Elegant teddy made of roses", 
                  "Personalized mug with your message", 
                  "Stylish LED-lit frame for photos"),
  Price = c(25, 15, 35),
  Availability = c("In Stock", "In Stock", "Limited Stock"),
  Rating = c(4.5, 4.7, 4.9),
  Image = c("Rose Teddy.jpg", "Customized Mug.jpg", "LED Frame.jpg"),
  stringsAsFactors = FALSE
)

# UI
ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  tags$head(tags$style(HTML("
    body { font-family: 'Segoe UI', sans-serif; background-color: #fafafa; }
    .product-image { width: 100%; height: 220px; object-fit: cover; border-radius: 8px; }
    .card { border: 1px solid #ddd; border-radius: 10px; padding: 15px; background: white; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
    .price { font-size: 1.2em; font-weight: bold; color: #E91E63; }
    .navbar-brand { font-size: 22px; font-weight: bold; }
    .section-title { margin-top: 30px; }
  "))),
  
  navbarPage("Gift Hub", id = "nav",
             
             tabPanel("Home",
                      fluidRow(
                        column(12, align = "center",
                               h2("Welcome to Gift Hub 🎁"),
                               p("Elegant gifts for every celebration — curated with love and care.")
                        )
                      ),
                      hr(),
                      fluidRow(
                        lapply(1:nrow(products), function(i) {
                          column(4, div(class = "card",
                                        img(src = products$Image[i], class = "product-image"),
                                        h4(products$Name[i]),
                                        p(products$Description[i]),
                                        span(class = "price", paste0("$", products$Price[i])),
                                        br(),
                                        actionButton(paste0("add_", i), "Add to Cart", icon = icon("cart-plus"))
                          ))
                        })
                      )
             ),
             
             tabPanel("Shop",
                      sidebarLayout(
                        sidebarPanel(
                          pickerInput("availability", "Filter by Availability",
                                      choices = unique(products$Availability),
                                      multiple = TRUE, selected = unique(products$Availability)),
                          sliderInput("price_range", "Price Range", min = 0, max = 50, value = c(0, 50))
                        ),
                        mainPanel(
                          DTOutput("shop_table")
                        )
                      )
             ),
             
             tabPanel("Cart",
                      h3("🛒 Shopping Cart"),
                      p("Cart functionality is under development."),
                      p("You will be able to see added items, update quantity, and proceed to checkout here.")
             ),
             
             tabPanel("Contact",
                      fluidRow(
                        column(6,
                               h3("Need Assistance?"),
                               p("Send us a message or reach out through our social platforms."),
                               textInput("name", "Name"),
                               textInput("email", "Email"),
                               textAreaInput("message", "Message", "", rows = 5),
                               actionButton("send_msg", "Send Message", class = "btn btn-primary")
                        ),
                        column(6,
                               h4("Connect With Us"),
                               tags$ul(
                                 tags$li(a("Facebook", href = "https://facebook.com", target = "_blank")),
                                 tags$li(a("Instagram", href = "https://instagram.com", target = "_blank")),
                                 tags$li(a("Twitter", href = "https://twitter.com", target = "_blank"))
                               )
                        )
                      )
             )
  )
)

# Server
server <- function(input, output, session) {
  
  filtered_products <- reactive({
    products[products$Price >= input$price_range[1] &
               products$Price <= input$price_range[2] &
               products$Availability %in% input$availability, ]
  })
  
  output$shop_table <- renderDT({
    datatable(filtered_products(), options = list(pageLength = 5))
  })
}

shinyApp(ui, server)
