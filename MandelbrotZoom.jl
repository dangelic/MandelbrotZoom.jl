using Images, Colors, ColorSchemes

# Calculates how many iterations are needed until z exceeds 3.
function calculate_divergence_iterations(c::Complex, max_iterations)
    z = Complex(0.0, 0.0)
    for iterations_to_divergence = 1:max_iterations
        z = z * z + c
        if abs2(z) > 3 # Consider > 3 as an indicator for z to diverge
            return iterations_to_divergence
        end
    end
    return Inf # > 3 is not reached in max_iterations loop. Consider no divergence
end

# Get color-coding depending on divergence rules.
function get_rgb(colorscheme, iteration, max_iterations)
    if step == Inf
        return RGB(0.0, 0.0, 0.0)  # Black for points that didn't diverge
    end
    factor = iteration / max_iterations # Scale [0, 1] to shade the "velocity" of divergence
    rgb = get(colorscheme, factor) 
    return rgb
end

# Paints an image.
function get_image(colorscheme, width, height, real_axis_min, real_axis_max, imaginary_axis_min, max_iterations)

    range = real_axis_max - real_axis_min
    point_size = range / width
    imaginary_axis_max = imaginary_axis_min + height * point_size

    image = zeros(RGB{Float64}, height, width)
    # Paints an image by looping through every x- and y-pixel in the real x imaginary canvas.
    for y = 1:height
        for x = 1:width
            real_part = real_axis_min + (x - 1) * point_size
            imaginary_part = imaginary_axis_max - (y - 1) * point_size
            c = Complex(real_part, imaginary_part)
            # Color the pixels.
            image[y, x] = get_color(colorscheme, calculate_divergence_iterations(c, max_iterations), max_iterations)
        end
    end
    return image
end


# TODO: Refactor, add zoom
function main()
    colorscheme = ColorSchemes.plasma # Change to matter, thermal, hawaii, berlin or any other found at https://docs.juliaplots.org/latest/generated/colorschemes/
    img_out = "mandelbrot_set_nozoom.bmp"
    max_iterations = 50 # Threshold for max loops until z - for given values - is considered as non-divergent.
    # y-axis => complex numbers
    # x-axis => real numbers
    width = 1000
    height = 600
    real_axis_min = -2.5
    real_axis_max = 1.5
    imaginary_axis_min = -1.2

    image = get_image(colorscheme, width, height, real_axis_min, real_axis_max, imaginary_axis_min, max_iterations)
    save(img_out, colorview(RGB, image))
end

main()
