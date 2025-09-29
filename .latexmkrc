# LaTeX VM Report Template - latexmk configuration
# This file configures latexmk for optimal building of the thesis

# Use pdflatex by default
$pdf_mode = 1;
$dvi_mode = 0;
$postscript_mode = 0;

# Use biber for bibliography processing
$biber = 'biber %O %S';
$bibtex_use = 2;

# Enable shell escape for minted syntax highlighting
$pdflatex = 'pdflatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Clean up more file types
$clean_ext = 'auxlock figlist makefile fls log fdb_latexmk out toc nav snm vrb bbl bcf blg idx ilg ind ist lof lot lol lst run.xml acn acr alg glg glo gls ist xdy synctex.gz upa upb pytxcode pythontex.makefile pythontex.fls pythontex.fdb_latexmk';

# Output directory
$out_dir = 'build';

# Automatically run latexmk when files change (for continuous preview)
$preview_continuous_mode = 1;

# PDF viewer settings
$pdf_previewer = 'start';  # Windows
if ($^O eq 'darwin') {     # macOS
    $pdf_previewer = 'open %O %S';
} elsif ($^O eq 'linux') { # Linux
    $pdf_previewer = 'xdg-open %O %S';
}

# Maximum number of compilation runs
$max_repeat = 5;

# Force mode (continue processing despite errors in non-critical files)
$force_mode = 1;

# Watch file extensions for changes
@default_files = ('main.tex');

# Additional dependencies to watch
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
    my ($base_name, $path) = fileparse($_[0]);
    pushd $path;
    my $return = system "makeglossaries", $base_name;
    popd;
    return $return;
}

# Custom dependency for minted cache
add_cus_dep('pytxcode', 'tex', 0, 'pythontex');
sub pythontex {
    return system("pythontex", $_[0]);
}

# Silence some warnings
$silence_logfile_warnings = 1;

# Show only errors and warnings
$show_time = 1;