import controlP5.*;
import java.util.HashMap;
import java.util.Map;
import javax.sound.midi.Receiver;
import javax.sound.midi.MidiMessage;
import processing.serial.*;
import blobDetection.*;
import drop.*;

BlobDetection theBlobDetection;
SimpleOpenNI simpleOpenNI;

ControlFrame cf;
//Handle hd;
ControlP5 textINPUT;


public int pixNUM = 0;
public int briNUM = 255;

int minDepth =  60;
int maxDepth = 860;

int targetX, targetY;
int xPos, yPos;
int lerpX, lerpY;

//블랍 크기
int blobWidth;
int blobheight;
int blobSize;

PFont font, moduleF;
PImage grid, grid_G, grid_R ;
PImage pixImage;
PImage depthImg;
PImage img;

String textValue = "";
String dir = "";
Textfield myTextfield;


float speed;
float pos;
float c0, c1, c2, c3;
boolean auto;
boolean testMODE = false;
boolean RECmode = false;
boolean onePlayer = false;
boolean powerSwitch = false;


color cellNumC = color(255);
color moduleNumC = color(33, 127, 255);
color emptyCC = color(30);
color red = color(255, 0, 0);

int rows, cols;
int cellSizeW, cellSizeH;
int bri; //포인트의 밝기
int cellNum = 0;
int Ypos;

int port = 1;

int[] testCELLx = new int[600]; 
int[] testCELLy = new int[600]; 

int testCell=0;

//SMPS 과부하 최대치
int pwLimit = 8;


int[] totalPW = new int[12];

boolean numText = false;
boolean module = false;

//SMPS 과부하 제어
boolean overLoad = false;

Serial myPort1, myPort2, myPort3, myPort4, myPort5, myPort6;
Serial[] myPort;


PrintWriter output1, output2, output3, output4, output5, output6, output7, output8;









int[][] cellNumMap = 
  {{-1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
  {-1, -1, -1, -1, -1, -1, -1, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, -1, -1, -1, -1, -1, -1, -1}, 
  {-1, -1, -1, -1, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, -1, -1, -1, -1, -1}, 

  {-1, -1, -1, -1, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, -1, -1, -1, -1}, 
  {-1, -1, -1, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, -1, -1, -1}, 
  {-1, -1, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, -1, -1}, 
  {-1, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, -1}, 

  {148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177}, 
  {178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207}, 
  {208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237}, 
  {238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267}, 

  {268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297}, 
  {298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327}, 
  {328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357}, 
  {358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387}, 

  {-1, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, -1}, 
  {-1, -1, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, -1, -1}, 
  {-1, -1, -1, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, -1, -1, -1}, 
  {-1, -1, -1, -1, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, -1, -1, -1, -1}, 

  {-1, -1, -1, -1, -1, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, -1, -1, -1, -1, -1}, 
  {-1, -1, -1, -1, -1, -1, -1, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, -1, -1, -1, -1, -1, -1, -1}, 
  {-1, -1, -1, -1, -1, -1, -1, -1, -1, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, -1, -1, -1, -1, -1, -1, -1, -1, -1}};





int[][] portMap = 
  {{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 

  {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}, 
  {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}, 
  {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}, 
  {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 2}, 

  {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}, 
  {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}, 
  {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}, 
  {3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}, 

  {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}, 
  {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}, 
  {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}, 
  {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}, 

  {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}, 
  {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}, 
  {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}, 
  {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 5, 5, 5, 5}, 

  {6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6}, 
  {6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6}, 
  {6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6}};





int[] PCBnum = 
  {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 
  13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 
  29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 

  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 
  11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 
  23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 
  36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 60, 61, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 124, 125, 

  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 
  15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 
  30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 
  45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 

  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 
  15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 
  30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 
  45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 

  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 
  14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 
  27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 
  39, 40, 41, 42, 43, 44, 45, 46, 47, 60, 61, 87, 88, 89, 90, 91, 92, 93, 94, 95, 124, 125, 

  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 
  37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47};



//SMPS 과부하 제어용 배열
int[] SMPS_01 = 
  {1, 2, 3, 4, 5, 6, 
  13, 14, 15, 16, 17, 18, 19, 20, 
  29, 30, 31, 32, 33, 34, 35, 36, 37, 38};

int[] SMPS_02 = 
  {7, 8, 9, 10, 11, 12, 
  21, 22, 23, 24, 25, 26, 27, 28, 
  39, 40, 41, 42, 43, 44, 45, 46, 47, 48};

int[] SMPS_03 = 
  {49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 
  71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 
  95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 
  121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134};

int[] SMPS_04 = 
  {60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 
  83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 
  108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 
  135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148};



int[] SMPS_05 = 
  {149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 
  179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 
  209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 223, 
  239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253};

int[] SMPS_06 = 
  {164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 
  194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 
  224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 
  254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268};

int[] SMPS_07 = 
  {269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 
  299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 
  329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 
  359, 360, 361, 362, 363, 364, 365, 367, 368, 369, 370, 371, 372, 373};

int[] SMPS_08 = 
  {284, 285, 286, 287, 288, 289, 290, 291, 293, 294, 295, 296, 297, 298, 
  314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 
  344, 345, 346, 347, 348, 349, 350, 351, 352, 352, 353, 354, 355, 356, 357, 358, 
  374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388};

int[] SMPS_09 = 
  {389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 
  417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 
  443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 
  467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477};

int[] SMPS_10 = 
  {403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 
  430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 
  455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 
  478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488};

int[] SMPS_11 = 
  {489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 
  509, 510, 511, 512, 513, 514, 515, 516, 
  525, 526, 527, 528, 529, 530};

int[] SMPS_12 = 
  {499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 
  517, 518, 519, 520, 521, 522, 523, 524, 
  531, 532, 533, 534, 535, 536};














void settings() {
  size(600, 594);
  smooth(8);
}

void setup() {
  



  try {  
  

  dir = sketchPath();
  depthImg = new PImage(512, 424);
  img = new PImage(512, 424);

  grid = loadImage("grid.jpg");
  grid_G = loadImage("grid_G.jpg");
  grid_R = loadImage("grid_R.jpg");
  pixImage  = createImage(600, 594, RGB);

  myPort = new Serial[8];

  colorMode(RGB);
  frameRate(30);
  font= createFont("BitstreamVeraSansMono", 10);
  moduleF= createFont("BitstreamVeraSa`nsMono", 40);
  rectMode(CENTER); 
  ellipseMode(CENTER);

  //전자석 배열 개수 : 가로 30 x 세로 22
  cellSizeW = 20;
  cellSizeH = 27;


  rows = width / cellSizeW;
  cols = height / cellSizeH;  
  
  

  printArray(Serial.list());
  
  
  String portName1 = Serial.list()[1];
  String portName2 = Serial.list()[5];
  String portName3 = Serial.list()[6];
  String portName4 = Serial.list()[3];
  String portName5 = Serial.list()[4];
  String portName6 = Serial.list()[2]; 
  
  String switchPort = Serial.list()[8]; 


  println("select port1: "+portName1);
  println("select port2: "+portName2);
  println("select port3: "+portName3);
  println("select port4: "+portName4);
  println("select port5: "+portName5);
  println("select port6: "+portName6);
  println("select switchPort: "+switchPort);
  println("---------------------------------------------------------------------------");


  myPort[1] = new Serial(this, portName1, 250000);
  myPort[2] = new Serial(this, portName2, 250000);
  myPort[3] = new Serial(this, portName3, 250000);
  myPort[4] = new Serial(this, portName4, 250000);
  myPort[5] = new Serial(this, portName5, 250000);
  myPort[6] = new Serial(this, portName6, 250000);
  myPort[7] = new Serial(this, switchPort, 9600);


  cf = new ControlFrame(this, 800, 1010, "Controls");
  cf.controlSC = createImage(800, 1010, RGB);

  textINPUT = new ControlP5(this);
  myTextfield = textINPUT.addTextfield(" cell test")
    .setPosition(4, 4)
    .setSize(60, 20)
    .setFocus(true)
    ;
  textINPUT.addButton("submit", 0, 70, 4, 40, 20);


  theBlobDetection = new BlobDetection(512, 424);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.2f); // will detect bright areas whose luminosity > 0.2f;


  surface.setLocation(601, 160);
  noStroke();
   }
    catch (ArrayIndexOutOfBoundsException e) {
    
    println("error reset!");
    setup();
  } 

  
} 

void draw() {


  background(100);

  for (int i = 0; i < cols; i++) {

    for (int j = 0; j < rows; j++) {

      int x = j * cellSizeW;
      int y = i * cellSizeH;

      //픽셀 중심부 컬러
      int xC = j * cellSizeW +  cellSizeW/2;
      int yC = i * cellSizeH +  cellSizeH/2;

      int loc = (cf.controlSC.width + xC) + yC *cf.controlSC.width; // Reversing x to mirror the image
      //int loc = (this.width - x - 1) + y*this.width; // Reversing x to mirror the image
      color c = cf.controlSC.pixels[loc];

      if ((int)red(c) <= 255 && (int)green(c) == 0 && (int)blue(c) == 0) {
        bri =0;
      } else if ((int)red(c) == 0 && (int)green(c) <= 255 && (int)blue(c) == 0) {
        bri = 0;
      } else {
        bri = (int)brightness(c);
      }
      ;


      fill(bri);
      noStroke();
      // rectMode(CENTER);
      //rect(x + cellSizeW/2, y + cellSizeH/2, cellSizeW-1, cellSizeH-1); 


      if (cellNumMap[i][j] != -1) {
        rect(x + cellSizeW/2, y + cellSizeH/2, cellSizeW-1, cellSizeH-1); 
        myPort[portMap[i][j]].write( "$LED" + "," + str(PCBnum[cellNumMap[i][j]]) + "," + str(bri) + "\n");
      }
    }
  }
}






void SMPScheck(int num, int[] smps, int p, int PW) {

  for (int n=0; n < smps.length; n++) {

    //println("tern = " + n);

    if (num+1 == smps[n]) {


      if (PW >= 1) {  
        // println("왼쪽 " + n);
        totalPW[p]++;
      } else {
        //totalPW--;
      }
    }
  }
}


void overload() {

  //SMPS 과부하 제어
  if (totalPW[0] >= pwLimit) {
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height);

    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[1] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[2] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[3] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[4] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[5] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[6] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[7] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[8] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[9] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[10] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else if (totalPW[11] >= pwLimit) {   
    overLoad = true;
    fill(255, 0, 0);
    rect(width/2, height/2, width, height); 
    cf.slider1 = 0;
    cf.slider2 = 0;
    cf.slider3 = 0;
    cf.slider4 = 0;
    cf.slider5 = 0;
    cf.slider6 = 0;
    cf.slider7 = 0;
    cf.slider8 = 0;
  } else {
    overLoad = false;
    fill(80);
    rect(width/2, height/2, width, height);


    cf.slider1 = cf.slider1;
    cf.slider2 = cf.slider2;
    cf.slider3 = cf.slider3;
    cf.slider4 = cf.slider4;
    cf.slider5 = cf.slider5;
    cf.slider6 = cf.slider6;
    cf.slider7 = cf.slider7;
    cf.slider8 = cf.slider8;
  }


  totalPW[0] = 0;
  totalPW[1] = 0;
  totalPW[2] = 0;
  totalPW[3] = 0;
  totalPW[4] = 0;
  totalPW[5] = 0;
  totalPW[6] = 0;
  totalPW[7] = 0;
  totalPW[8] = 0;
  totalPW[9] = 0;
  totalPW[10] = 0;
  totalPW[11] = 0;
}





void submit(int theValue) {
  myTextfield.submit();
}