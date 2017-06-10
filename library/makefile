SOURCE_DIR = src
OBJ_DIR = bin
DEPEND_DIR = depend
INCLUDE_DIR = include
LIB_DIR = lib

TEST_DIR = test

VERSION_STAGE = alpha
VERSION_MAJOR = 0
VERSION_MINOR = 0
VERSION_PATCH = 0

BASE_NAME = sampleLibrary
TARGET = lib$(BASE_NAME)-$(VERSION_MAJOR)-$(VERSION_MINOR)-$(VERSION_PATCH)-$(VERSION_STAGE).so
TARGET_LINK = lib$(BASE_NAME).so
BASE_NAME_DEFINE = $(subst -,_,$(shell echo $(BASE_NAME) | tr '[:lower:]' '[:upper:]'))

CPP_FILES = $(shell find $(SOURCE_DIR) -type f -name "*.cpp" -printf '%p ')
OBJ_FILES = $(subst $(SOURCE_DIR),$(OBJ_DIR),$(patsubst %.cpp,%.o,$(CPP_FILES)))

VERSION_FLAGS=-D$(BASE_NAME_DEFINE)_VERSION_STAGE="$(VERSION_STAGE)" -D$(BASE_NAME_DEFINE)_VERSION_MAJOR="$(VERSION_MAJOR)" -D$(BASE_NAME_DEFINE)_VERSION_MINOR="$(VERSION_MINOR)" -D$(BASE_NAME_DEFINE)_VERSION_PATCH="$(VERSION_PATCH)"
CXX = clang++
DEBUG_FLAGS = -g -O0
WARNING_FLAGS = \
	-ferror-limit=5 \
	-Werror \
	-Wall \
	-Wextra \
	-Wwrite-strings \
	-Winit-self \
	-Wcast-align \
	-Wcast-qual \
	-Wold-style-cast \
	-Wpointer-arith \
	-Wstrict-aliasing \
	-Wformat=2 \
	-Wuninitialized \
	-Wmissing-declarations \
	-Woverloaded-virtual \
	-Wnon-virtual-dtor \
	-Wctor-dtor-privacy \
	-Wno-long-long \
	-Weffc++
STD = -std=c++14 -pedantic
INCLUDES = -I $(SOURCE_DIR) -I $(INCLUDE_DIR)
LDLIBS = -lsampleLibrary
LDFLAGS = $(INCLUDES) $(STD) -shared -fPIC $(WARNING_FLAGS) $(DEBUG_FLAGS) -L $(LIB_DIR) $(LDLIBS)
CXXFLAGS = $(INCLUDES) $(STD) -fPIC $(WARNING_FLAGS) $(DEBUG_FLAGS)

PREFIX = /usr/lib
DOXYFILE = Doxyfile

.PHONY : clean install uninstall test doc

$(TARGET) : $(OBJ_FILES)
	$(CXX) $(LDFLAGS) $(OBJ_FILES) -o $@

$(OBJ_DIR)/%.o : $(SOURCE_DIR)/%.cpp $(DEPEND_DIR)/%.d
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $(SOURCE_DIR)/$*.cpp -o $@

$(DEPEND_DIR)/%.d : $(SOURCE_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -MM $< > $@
	@sed -i "1s~^~$(subst $(DEPEND_DIR),$(OBJ_DIR),$(dir $@))~" $@

install: $(TARGET)
	install -m 755 $(TARGET) $(PREFIX)/$(TARGET)
	ln -sf $(PREFIX)/$(TARGET) $(PREFIX)/$(TARGET_LINK)

uninstall:
	$(RM) -f $(PREFIX)/$(TARGET) $(PREFIX)/$(TARGET_LINK)

clean :
	$(RM) -r $(OBJ_DIR) $(DEPEND_DIR) $(TARGET) $(DOC_DIR)
	$(MAKE) -C ./$(TEST_DIR) clean

test : $(OBJ_FILES)
	$(MAKE) -C ./$(TEST_DIR)

doc :
	@mkdir -p $(DOC_DIR)
	doxygen $(DOXYFILE)

-include $(subst $(OBJ_DIR),$(DEPEND_DIR),$(patsubst %.o,%.d,$(OBJ_FILES)))
