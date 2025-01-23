


# Open-Source Ada: From Gateware to Application

In this post, we explore building a fully open-source bare-metal Ada application on top of an open-source circuit design using an open-source toolchain, from software to gateware. 

## The goal
The goal of this post is to make “the Ada way” clearer—where it stands in the programming landscape and what it’s truly capable of. As Ada enthusiasts, we naturally grasp its nuances.
This blog post wants to talk to someone new or simply curious but also anyone accustomed to Ada who did not have the time to undergo the experiment I did. For new ones, understanding its essence is invaluable.
I want to show that Ada is not just a viable replacement for C—it’s a clean and simple one, once you have enough experience with it. On paper, Ada is a system programming language, which objectively means it’s suitable for low-level development. But what’s less obvious is how it actually handles these scenarios in practice.
Having a fully open-source toolchain removes any black-box elements, allowing everything to be examined and understood. Some parts may remain unexplored for now, but the key is that nothing is inherently hidden—everything can be understood. This cumulative effect of transparency and knowledge-building is what makes Ada so compelling.
For those driven by the pursuit of deeper understanding, setting up such a fully open environment is invaluable. Choosing open-source tools and hardware, making conscious design decisions, and committing to a structured approach allow for a complete and coherent story—one that connects arguments to real results. Taking an open-source RISC-V implementation and working through every low-level detail is how one can truly demystify an entire system, from gateware to application.




## The setup
### The dev board
The Radiona ULX3S is an open-source FPGA development board. It had a highly successful Crowd Supply campaign back in 2020. At its core, it features a Lattice ECP5 FPGA. While the ICs are proprietary, the board design itself is open source. I went with the version that has 85K lookup tables. 
For those new to this technology, an FPGA is a type of microchip where you can define and implement your own logic circuit. Since this circuit isn’t fixed and can be reprogrammed, we often refer to it as gateware, drawing a parallel with software. Instead of writing code that runs as sequential instructions on a processor, you’re describing how logic gates should be arranged to create the circuit you need. 
At engineering school we were exposed to code gateware using vhdl and at the time more complex circuits were realised using proprietary cores (IPs). to give an example a memory Xilinx was supplying the microblaze 

The goal of this blog post is to demystify Ada, where does it lies in the landscape, what it is capable of. As Ada enthusiasm it comes naturally to us to understand the subtleties or what is the “deal” with Ada, but for someone curious or just starting , wisdom is worth a lot. With this blog post I want to demonstrate that Ada is really a clean replacement to C, a simple one once you have enough wisdom in it. All this is common knowledge if you strictly interpret what is on paper, eg. Ada is a system programming language objectively implies that ist good or relevant for very low level implementation. What is less evident is how actually it deals with such context. Having a totally opensource chain of production enables one to suspend any potential magic parts. Some parts may stay magic for the actual time but the fact is that it has the total potential of being demystified completely. This is this compounding effect that is interesting and relevant. Also being strongly motivated by increasing knowledge, seting up such potential discoverability is amazing. By choosing, by approaching the commitment of certain piece and decision of knowledge, one controls and is enabled to make a full story, a story of arguments and results. To take an open source riscv implementation and dealing with every low level details enable ones to qualify the “whole story” of implementation, its demystify correctly. 

This has become my go-to line for holiday small talk—to either impress or swiftly scare off family members.
This is meant to be a generous piece, so I'll aim to entertain both the unacquainted and the technically inclined. Feel free to skip over sections that you find obvious.

Hit me

The Radiona ULX3S is a development board featuring the Lattice ECP5 FPGA. My board uses the LFE5U-85F model, which provides 85,000 LUTs—one of the key FPGA resources. More on that later.

An FPGA (Field-Programmable Gate Array) is an integrated circuit that allows you to program its hardware to create custom architectures or electrical circuits, often called hardware accelerators. Programming an FPGA involves loading it with a bitstream, which configures its internal logic.

Yosys is an open-source RTL (Register-Transfer Level) synthesis tool. It converts your circuit design, written in a hardware description language like Verilog, into a netlist—a representation of the design using basic FPGA components like LUTs and BRAMs.

Look-Up Tables (LUTs) are key building blocks in an FPGA, used to implement truth tables for circuits. They handle chains of logic or boolean expressions, enabling states and computations. BRAMs (Block RAMs) are on-chip memory blocks within the FPGA, used to implement storage like memories, registers, and other data-holding structures.

Trellis is an open-source project documenting the ECP5 bitstream, mapping bits to FPGA resources. It lets you generate a meaningful bitstream to configure LUTs, BRAMs, and other FPGA components as needed.

Nextpnr is an open-source placement and routing tool. It uses the netlist from Yosys and the Trellis database to map your design onto the FPGA. For the 85k LUTs on my board, it optimizes resource usage by minimizing the number of LUTs and shortening electrical paths. This improves performance, as shorter paths mean faster computations.








Install litex: 
wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
chmod +x litex_setup.py
./litex_setup.py --init --install --config=full
pip3 install meson ninja

Libada story

Change IC fpga model if need be. I need to set at ac100
python3 -m litex_boards.targets.micronova_mercury2 --variant=a7-100 --build
Upload the bitstream:
ERROR: No Mercury 2 FPGA board found.

Please note that you may have to disable the FTDI VCP driver in order to use the D2XX driver.
You can do this by running: sudo rmmod ftdi_sio && sudo rmmod usbserial


sudo rmmod ftdi_sio && sudo rmmod usbserial
mercury2_prog -w build/micronova_mercury2/gateware/micronova_mercury2.bit
ls /dev/ttyUSB*


















Clone litex
Investigate yosys









~/litex_experiment/litex-boards$ python3 -m litex_boards.targets.micronova_mercury2 --cpu-type=naxriscv --scala-args='rvc=true,rvf=true,rvd=true' --build --csr-svd=mercury2_naxriscv64.svd

sudo rmmod ftdi_sio && sudo rmmod usbserial

~/litex_experiment/litex-boards$ mercury2_prog -w build/micronova_mercury2/gateware/micronova_mercury2.bit


ls /dev/ttyUSB*

screen /dev/ttyUSB1 115200

Set /home/henley/.local/share/alire/toolchains/gnat_riscv64_elf_13.2.1_938f208c/bin/ on your path. (provide a gcc and gnat cross compipler)



