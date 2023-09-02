using Images, Colors, ColorSchemes

# Calculates how many iterations are needed until z exceeds 8, where this value depends on the zooming.
function calculate_divergence_iterations(c::Complex, max_iterations)
    z = Complex(0.0, 0.0)
    for iterations_to_divergence = 1:max_iterations
        z = z * z + c
        
        if abs2(z) > 4 # Consider > 8 as an indicator for z to diverge (adjusted threshold)
            return iterations_to_divergence
        end
    end
    return max_iterations + 1  # Adjusted to ensure unbounded points are colored differently
end

# Get color-coding depending on divergence rules.
function get_rgb(colorscheme, iterations_to_divergence, max_iterations)
    if iterations_to_divergence > max_iterations
        return RGB(0.0, 0.0, 0.0)  # Black for points that didn't diverge (adjusted condition)
    end
    factor = iterations_to_divergence / max_iterations  # Improved color mapping with log
    rgb = get(colorscheme, factor)
    return rgb
end

# Paints an image.
function get_image(colorscheme, width, height, real_axis_min, real_axis_max, imaginary_axis_min, max_iterations)
    range = real_axis_max - real_axis_min
    point_size = range / width
    imaginary_axis_max = imaginary_axis_min + height * point_size

    image = zeros(RGB{Float64}, height, width)

    for y = 1:height
        for x = 1:width
            real_part = real_axis_min + (x - 1) * point_size
            imaginary_part = imaginary_axis_max - (y - 1) * point_size
            c = Complex(real_part, imaginary_part)
            # Color the pixels.
            image[y, x] = get_rgb(colorscheme, calculate_divergence_iterations(c, max_iterations), max_iterations)
        end
    end

    return image
end

# Main function
function main()
    colorscheme = ColorSchemes.plasma # Change to matter, thermal, hawaii, berlin or any other found at https://docs.juliaplots.org/latest/generated/colorschemes/
    img_out = "mandelbrot_set_static.bmp"
    max_iterations = 50  # Increase the iterations for better detail
    width = 1000
    height = 600
    real_axis_min = -2.5
    real_axis_max = 1.5
    imaginary_axis_min = -1.2

    image = get_image(colorscheme, width, height, real_axis_min, real_axis_max, imaginary_axis_min, max_iterations)
    save(img_out, colorview(RGB, image))
end

main()