package com.shop.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

@Controller
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping("/products")
    public String list(Model model) {
        List<Product> products = productService.findAll();
        model.addAttribute("products", products);
        return "products";
    }

    @GetMapping("/products/{id}")
    public String details(@PathVariable("id") Long id, Model model) {
        Product p = productService.findById(id);
        model.addAttribute("product", p);
        return "product-details";
    }

    @PostMapping("/products/add")
    public String add(@ModelAttribute Product product) {
        productService.save(product);
        return "redirect:/products";
    }
}